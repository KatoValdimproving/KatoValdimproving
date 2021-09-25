//
//  User.swift
//  NovaTrack
//
//  Created by Developer on 1/18/18.
//  Copyright © 2018 Paul Zieske. All rights reserved.
//

import UIKit

struct User: Codable {
    
    let title: Int
    let id : String
    let created : String
    let userId : String
    let campusId: String
    let role: String
    let firstName: String
    let lastName: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case title = "ttl"
        case id
        case created
        case userId
        case user = "user"
        case campusId
        case role = "role_name"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
        try container.encode(created, forKey: .created)
        try container.encode(userId, forKey: .userId)
        
        var userContainer =  container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
        try userContainer.encode(campusId, forKey: .campusId)
        try userContainer.encode(role, forKey: .role)
        try userContainer.encode(firstName, forKey: .firstName)
        try userContainer.encode(lastName, forKey: .lastName)
        try userContainer.encode(email, forKey: .email)

    }
    
    init(title: Int, id: String, created: String, userId: String, campusId: String, role: String) {
        self.title = title
        self.id = id
        self.created = created
        self.userId = userId
        self.campusId = campusId
        self.role = role
        self.email = ""
        self.firstName = ""
        self.lastName = ""
    }
    
    init(title: Int, id: String, created: String, userId: String, campusId: String, role: String, firstName: String, lastName: String, email: String) {
        self.title = title
        self.id = id
        self.created = created
        self.userId = userId
        self.campusId = campusId
        self.role = role
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(Int.self, forKey: .title)
        id = try container.decode(String.self, forKey: .id)
        created = try container.decode(String.self, forKey: .created)
        userId = try container.decode(String.self, forKey: .userId)
        
        let userContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
        campusId = try userContainer.decode(String.self, forKey: .campusId)
        role = try userContainer.decode(String.self, forKey: .role)
        firstName = try userContainer.decode(String.self, forKey: .firstName)
        lastName = try userContainer.decode(String.self, forKey: .lastName)
        email = try userContainer.decode(String.self, forKey: .email)
    }
    
}
