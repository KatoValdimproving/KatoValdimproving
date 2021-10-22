//
//  Painting.swift
//  hfciPatientX
//
//  Created by developer on 20/10/21.
//

import UIKit

class Painting: NSObject {
   
    
    
    var name: String
    var title: String
    var author: String
    var text: String
    var origin: String
    var technique: String
    var year: String
    var isGroup = false
    
    override init() {
        name = ""
        title = ""
        author = ""
        text = ""
        origin = ""
        technique = ""
        year = ""
        super.init()

    }
    
     init(name: String, title: String, author: String, text: String, origin: String, technique: String, year: String) {
        self.name = name
        self.title = title
        self.author = author
        self.text = text
        self.origin = origin
        self.technique = technique
        self.year = year
    }

}
