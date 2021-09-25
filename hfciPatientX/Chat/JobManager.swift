//
//  JobManager.swift
//  NovaTrack
//
//  Created by developer on 2/14/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import Foundation


struct JobManager: Codable {
    
    let jobId : String
    var shortPayload : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case jobId = "jobId"
        case shortPayload = "shortPayload"
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jobId, forKey: .jobId)
        try container.encode(shortPayload, forKey: .shortPayload)
        
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jobId = try container.decode(String.self, forKey: .jobId)
       // shortPayload = try container.decode(Bool.self, forKey: .shortPayload)
        shortPayload = try container.decodeIfPresent(Bool.self, forKey: .shortPayload) ?? false
    }
    
    
    static var jobId : String? {
        get {
            return  UserDefaults.standard.string(forKey: "jobId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "jobId")
        }
    }
    
    static var shortPayload : Bool {
        get {
            return  UserDefaults.standard.bool(forKey: "shortPayload")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shortPayload")
        }
    }
    
}
