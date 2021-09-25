//
//  ChatUser.swift
//  NovaTrack
//
//  Created by Juan Pablo Rodriguez Medina on 28/02/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import UIKit

struct ChatUser:Decodable {
    
    enum Status:String {
        case online = "online"
        case offline = "offline"
        case inactive = "inactive"
        case broadcast = "broadcast"
        case unknown
    }
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case channel = "channel"
        case name = "name"
        case roleName = "role_name"
        case status = "status"
        case unreadMessages = "unreadMsgs"
        case phoneNumber = "phone_number"
        case email = "email"

    }
    
    let id:String
    var channel:String
    let fullName:String
    var firstName:String?
    var lastName:String?
    var initials:String?
    let roleName:String
    var status:Status
    var unreadMessages:Int
    var phoneNumber: String?
    var email: String?
    
    init(id: String, channel: String, fullName: String, firstName: String, lastName: String, initials: String, roleName: String, status: Status, unreadMessages: Int) {
        self.id = id
        self.channel = channel
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName
        self.initials = initials
        self.roleName = roleName
        self.status = .online
        self.unreadMessages = unreadMessages
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.channel = try container.decode(String.self, forKey: .channel)
        self.fullName = try container.decode(String.self, forKey: .name)
        self.roleName = try container.decode(String.self, forKey: .roleName)
        self.status = Status(rawValue: try container.decode(String.self, forKey: .status)) ?? .unknown
        self.unreadMessages = try container.decode(Int.self, forKey: .unreadMessages)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)

        let formatter = PersonNameComponentsFormatter()
        let components = formatter.personNameComponents(from: self.fullName)
        if let firstName = components?.givenName,
            let firstNameInitial = firstName.first,
            let lastName = components?.familyName,
            let lastNameInitial = lastName.first {
            self.firstName = firstName
            self.lastName = lastName
            self.initials = "\(firstNameInitial)\(lastNameInitial)"
        }
    }
    
    mutating func updateStatus(status:Status, channel:String) {
        self.status = status
        self.channel = channel
    }
    
    mutating func setUnread(_ count:Int) {
        self.unreadMessages = count
    }
}
