//
//  Beacon.swift
//  hfciPatientX
//
//  Created by developer on 24/10/21.
//

import UIKit
import CoreLocation

class Beacon: NSObject {
    
    init(uuid: UUID, mayor: Int, minor: Int, firstContact: Date? = nil, time: Double, distance: Double, identifier: String, paintings: [Painting] = [], proximity: Double = 0, rrsi: Int = 0, location: String) {
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
        self.location = location
        super.init()
        
        for paintin in self.paintings {
            paintin.beacon = self
        }
    }
    
    var clproximity: CLProximity = .unknown //{
    //        didSet {
    //            switch clproximity {
    //            case .unknown:
    //                 isInDesiredDistance = false
    //                firstContact = nil
    //            case .far:
    //                isInDesiredDistance = false
    //               firstContact = nil
    //            case .immediate, .near:
    //                isInDesiredDistance = true
    ////            case .near:
    ////                isInDesiredDistance = false
    ////               firstContact = nil
    //            @unknown default:
    //                isInDesiredDistance = false
    //               firstContact = nil
    //            }
    //        }
    //  }
    var noise: [Double] = [] {
        didSet {
            if noise.count == 8 {
                
                if noise.allSatisfy({ element in
                    element == -1
                }) {
                    print("🎃 all bad \(noise)")
                    
                    proximity = -1
                    
                } else {
                    print("🎃 check for -1 and delete them \(noise)")
                    if noise.contains(-1) {
                        print("🎃 noise contains -1")

                        noise.removeAll { element in
                            element == -1
                        }
                        
                        print("🎃 when -1 deleted \(noise)")

                    }
                    
                    let sum = noise.sum()
                    let mean = sum / Double(noise.count)
                  //  proximity = mean
                    print("🎃 mean \(mean)")
                    
                    if mean <=  distance  && mean > -1 {
                        isInDesiredDistance = true
                    } else {
                        isInDesiredDistance = false
                        firstContact = nil
                        
                    }

                }
                
                noise = []
            }
        }
    }
    var location: String
    var isSelected = false
    var uuid: UUID
    var mayor: Int
    var minor: Int
    var firstContact: Date?
    var time: Double = 10
    var distance: Double = 100
    var isInDesiredDistanceAndTime = false
    var didPostBeaconInfo = false
    var isInDesiredDistance = false {
        didSet {
            
            if isInDesiredDistance {
                if firstContact == nil {
                    firstContact = timeStamp
                } else {
                    let now = Date()
                    let elapsedTime = now.timeIntervalSince(firstContact!)
                    //  let elapsedTime = firstContact?.timeIntervalSince(now)
                    print("⚡️ elapsed time \(String(describing: elapsedTime)) for mayor \(mayor)")
                    if elapsedTime >= time {
                        print("⚡️❤️ Ya paso \(time) segundos para \(mayor)")
                        //firstContact = nil
                        isInDesiredDistanceAndTime = true
                        if didPostBeaconInfo == false {
                            NotificationCenter.default.post(name: Notification.Name("didRangedPainting"), object: self, userInfo: ["key": self])
                            didPostBeaconInfo = true
                        }
                        
                    } else {
                        //  print("⚡️ todavia no \(mayor)")
                        isInDesiredDistanceAndTime = false
                        didPostBeaconInfo = false
                        
                    }
                    
                    
                }
            } else {
                isInDesiredDistanceAndTime = false
                didPostBeaconInfo = false
                
            }
        }
    }
    var identifier: String
    var paintings: [Painting] = []
    var proximity: Double = 0 {
        didSet {
            print("🎃🎃 input \(mayor) \(proximity)")
            noise.append(proximity)

//            if proximity <=  distance  && proximity > -1 {
//                isInDesiredDistance = true
//            } else {
//                isInDesiredDistance = false
//                firstContact = nil
//
//            }
            
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
