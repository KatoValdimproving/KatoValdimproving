//
//  Message.swift
//  NovaTrack
//
//  Created by Juan Pablo Rodriguez Medina on 02/03/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import Foundation
import SocketIO

struct IsBroadcast: Decodable {
    var name: String
    var roleName: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case roleName = "role_name"
    }
}

struct Message:SocketData, Decodable {
    
    enum CodingKeys:String, CodingKey {
        case id = "_id"
        case text = "text"
        case origin = "origin"
        case destiny = "destiny"
        case status = "status"
        case channel = "channel"
        case creationDate = "creationDate"
        case seen = "seen"
        case isBroadcast = "isBroadcast"

    }
    
    let id:String
    let text:String
    let origin:String
    let destiny:String
    let status:Int
    let channel:String
    let creationDate:Date?
    let seen:Bool
    var isBroadcast: IsBroadcast? = nil
    
    init(id:String, text:String, origin:String, destiny:String, status:Int, channel:String, creationDate:Date, seen:Bool) {
        self.id = id
        self.text = text
        self.origin = origin
        self.destiny = destiny
        self.status = status
        self.channel = channel
        self.creationDate = creationDate
        self.seen = seen
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.origin = try container.decode(String.self, forKey: .origin)
        self.destiny = try container.decode(String.self, forKey: .destiny)
        self.status = try container.decode(Int.self, forKey: .status)
        self.channel = try container.decode(String.self, forKey: .channel)
        let strDate = try container.decode(String.self, forKey: .creationDate)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds]
        let date = dateFormatter.date(from: strDate)
        self.creationDate = date
        self.seen = try container.decode(Bool.self, forKey: .seen)
        self.isBroadcast = try container.decodeIfPresent(IsBroadcast.self, forKey: .isBroadcast)
    }
    
    func socketRepresentation() -> SocketData {
        
        var strDate:String = String()
        if let date = self.creationDate {
            let dateFormatter = ISO8601DateFormatter()
            strDate = dateFormatter.string(from: date)
        }
        
        return ["text":self.text, "origin":self.origin, "destiny":self.destiny, "status":self.status,
            "channel":self.channel, "creationDate":strDate]
    }
}
