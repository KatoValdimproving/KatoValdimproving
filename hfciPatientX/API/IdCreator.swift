//
//  IdCreator.swift
//  NovaTrack
//
//  Created by developer on 1/25/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import UIKit

class IdCreator: NSObject {

    static  var logId : Int {
        get {
            let idNumber = UserDefaults.standard.integer(forKey: "logId")
            UserDefaults.standard.set(idNumber + 1, forKey: "logId")
            return idNumber
        }
    }
    
    static var currentId: Int {
        get {
                   let currentIdNumber = UserDefaults.standard.integer(forKey: "logId")
                  // UserDefaults.standard.set(idNumber + 1, forKey: "logId")
            return currentIdNumber > 0 ? currentIdNumber - 1 :  currentIdNumber
               }
    }
    
}

class ChunkIdCreator: NSObject {

    static  var chunkId : Int {
        get {
            let idNumber = UserDefaults.standard.integer(forKey: "chunkId")
          //  UserDefaults.standard.set(idNumber, forKey: "chunkId")
            return idNumber
        }
        
        set {
          //  let idNumber = UserDefaults.standard.integer(forKey: "chunkId")
             UserDefaults.standard.set(newValue, forKey: "chunkId")

        }
        
        
    }
    
    static func incrementChunkId() {
        chunkId += 1
    }
    
}
