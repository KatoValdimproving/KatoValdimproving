//
//  Beacon.swift
//  hfciPatientX
//
//  Created by developer on 24/10/21.
//

import UIKit

class Beacon: NSObject {
   
    internal init(uuid: UUID, mayor: Int, minor: Int, firstContact: Date? = nil, time: Double, distance: Double, identifier: String, paintings: [Painting] = [], proximity: Double = 0, rrsi: Int = 0) {
        self.uuid = uuid
        self.mayor = mayor
        self.minor = minor
        self.firstContact = firstContact
        self.time = time
        self.distance = distance
        self.identifier = identifier
        self.paintings = paintings
        self.proximity = proximity
        self.rrsi = rrsi
        
    }
    
    

    var isSelected = false
    var uuid: UUID
    var mayor: Int
    var minor: Int
    var firstContact: Date?
    var time: Double = 10
    var distance: Double = 100
    var isInDesiredDistanceAndTime = false
    var isInDesiredDistance = false {
        didSet {
            
            if isInDesiredDistance {
            if firstContact == nil {
               firstContact = timeStamp
            } else {
                let now = Date()
                let elapsedTime = now.timeIntervalSince(firstContact!)
                print("⚡️ elapsed time \(elapsedTime) for mayor \(mayor)")
                if elapsedTime >= time {
                    print("⚡️❤️ Ya paso \(time) segundos para \(mayor)")
                    //firstContact = nil
                    isInDesiredDistanceAndTime = true
                } else {
                  //  print("⚡️ todavia no \(mayor)")
                    isInDesiredDistanceAndTime = false
                }
                
                
            }
            } else {
                isInDesiredDistanceAndTime = false
            }
        }
    }
    var identifier: String
    var paintings: [Painting] = []
    var proximity: Double = 0 {
        didSet {
            if proximity <=  distance  && proximity > -1 {
                isInDesiredDistance = true
            } else {
                isInDesiredDistance = false
                firstContact = nil

            }
        }
    }
    var rrsi: Int = 0
    var timeStamp: Date = Date()
    

}


class TimeManager {
    
    static let shared = TimeManager()
    private var startDate = CFAbsoluteTimeGetCurrent()

    init() { }
    
    func hasTimeElpased(seconds: Double) -> Bool {
        if elapsedTime(start: startDate) >= seconds {
            self.startDate = CFAbsoluteTimeGetCurrent()
            return true
        } else {
            return false
        }
    }
    
    private func elapsedTime(start: CFAbsoluteTime) -> Double {
        return CFAbsoluteTimeGetCurrent() - start
    }
    


}
