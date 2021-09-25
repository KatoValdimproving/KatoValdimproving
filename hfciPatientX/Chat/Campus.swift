//
//  Campus.swift
//  NovaTrack
//
//  Created by developer on 3/12/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import UIKit

struct Campus: Codable {
    
    let id: String
    let name: String
    let alias: String
   // var campusIMDF: CampusIMDF = CampusIMDF.allegiance(.allegiance)
    
    enum CodingKeys: String, CodingKey {
         
           case id
           case name
           case alias
          
       }
       
       func encode(to encoder: Encoder) throws {
           
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(id, forKey: .id)
           try container.encode(name, forKey: .name)
           try container.encode(alias, forKey: .alias)


       }
       
       init(from decoder: Decoder) throws {
           
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        alias = try container.decode(String.self, forKey: .alias)
        let name = try container.decode(String.self, forKey: .name)
        self.name = name
       // self.campusIMDF.setUp(name: self.name)
       
    }
    
    
    
    
    
}
