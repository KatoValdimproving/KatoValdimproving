//
//  Painting.swift
//  hfciPatientX
//
//  Created by developer on 20/10/21.
//

import UIKit

class Painting: NSObject {
    
    
    init(name: String, title: String, author: String, text: String, origin: String, technique: String, year: String, isGroup: Bool = false, beacon: Beacon? = nil, location: String) {
        self.name = name
        self.title = title
        self.author = author
        self.text = text
        self.origin = origin
        self.technique = technique
        self.year = year
        self.isGroup = isGroup
        self.beacon = beacon
        self.location = location
    }
        
    var name: String
    var title: String
    var author: String
    var text: String
    var origin: String
    var technique: String
    var year: String
    var isGroup = false
    var beacon: Beacon?
    var location: String
    
//    override init() {
//        name = ""
//        title = ""
//        author = ""
//        text = ""
//        origin = ""
//        technique = ""
//        year = ""
//        super.init()
//
//    }
    
//     init(name: String, title: String, author: String, text: String, origin: String, technique: String, year: String) {
//        self.name = name
//        self.title = title
//        self.author = author
//        self.text = text
//        self.origin = origin
//        self.technique = technique
//        self.year = year
//    }
    
   

}
