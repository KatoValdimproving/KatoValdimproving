//
//  LocationStreaming.swift
//  NovaTrack
//
//  Created by developer on 12/19/19.
//  Copyright © 2019 Paul Zieske. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftySound

class LocationStreaming {
    
    static let sharedInstance = LocationStreaming()
    typealias streamingClousure = (Bool, [CLLocation]) -> Void
    // var didStreamThroughtSocketIO: streamingClousure?
    var collectionClosures = [streamingClousure]()
    
    var distance: Double? {
           get {
               return  UserDefaults.standard.double(forKey: "distance")
           }
           set {
               UserDefaults.standard.setValue(newValue, forKey: "distance")
           }
       }
    var isFilterActive = false

    private init() { }
    
    @available(iOS 13.4, *)
    func streamLocation() {
//        let df = DateFormatter()
//        df.dateFormat = "y-MM-dd H:mm:ss.SSSS"
//
//        var lastLocationDate = Date()
//        print("✋ No last location \(df.string(from: lastLocationDate))")
//        let loc = [CLLocation(latitude: 0, longitude: 0)]
//        let noDelta = "No last location \(df.string(from: lastLocationDate))"
//
//        CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: [CLLocation(latitude: 0, longitude: 0)], discarded: false, madeForTraceHealing: false, isSocketIOEnabled: false, isNetworkAvailable: false, delay: noDelta )
//        self.sendToStream(locations: loc, delta: noDelta)

//        LocationManager.sharedInstance.getLocation {  (locations) in
//
//
//            guard let newLastLocation = LocationManager.sharedInstance.lastLocation else { return }
////            let delayTime = lastLocationDate.timeIntervalSince(newLastLocation.timestamp)
////                print("✋ \(delayTime)")
//            print("✋ last location \(df.string(from: lastLocationDate))")
//
//            print("✋newest location \(df.string(from: newLastLocation.timestamp))")
//
////         print("✋ last \(df.string(from: d))")
////            print("✋ newest \(newLastLocation.timestamp.timeIntervalSinceReferenceDate)")
//
//
//            let deltaTimeDouble =  newLastLocation.timestamp.timeIntervalSinceReferenceDate - lastLocationDate.timeIntervalSinceReferenceDate
//            if deltaTimeDouble < 0 { return}
//            let deltaTimeString =  String(format: "%.4f", deltaTimeDouble)
//           // let deltaTime = "\(df.string(from: newLastLocation.timestamp)) - \(df.string(from: lastLocationDate)) = \(deltaTimeString)"
//           let deltaTime = "\(newLastLocation.timestamp.stringFromDateZuluFormat()) - \(lastLocationDate.stringFromDateZuluFormat()) = \(deltaTimeString)"
//
//            lastLocationDate = newLastLocation.timestamp
//
//            print("✋ delta \(deltaTime)")
//
//             //   CoreDataManager.sharedInstance.addLogDelay(date: Date(), delay: "\(delayTime)")
//
//          //  }
//
////            guard let lastLocation = LocationManager.sharedInstance.lastLocation else {
////                print("✋ No last location \(Date())")
//             //   SessionManager.shared.lastLocationTime = "No last location \(Date())"
//             //   CoreDataManager.sharedInstance.addLogDelay(date: Date(), delay: "No last location first location")
//             //   return }
////            print("✋ \(lastLocation.timestamp)")
////            guard let location = locations.first else { return }
////            print("✋ \(location.timestamp)")
////
////            let delayTime = lastLocation.timestamp.timeIntervalSince(location.timestamp)
//
////            let interval = Int(delayTime)
////                let seconds = interval / 60
////                let secondsDescrp = String(format: "%02d", seconds)
////            let formatter = DateComponentsFormatter()
////            formatter.allowedUnits = [.second, .second]
////            let time = formatter.string(from: delayTime)
//
//            if SessionManager.shared.isLogedIn == false {
//                //print("💛 if SessionManager.shared.isLogedIn == false { return }")
//                return }
//
//
//            guard let location = locations.last, let lastLocation = LocationManager.sharedInstance.lastLocation else { //print("💛 guard let location = locations.last, let lastLocation = LocationManager.sharedInstance.lastLocation else { return }");
//                return }
            //print("💛 guard let location = locations.last, let lastLocation = LocationManager.sharedInstance.lastLocation else { return }");
               
            
            //Delay between them
//            let formatter = DateComponentsFormatter()
//            formatter.allowedUnits = [.nanosecond]
//               formatter.unitsStyle = .full
//               let difference = formatter.string(from: lastLocation.timestamp, to: location.timestamp)!
            //   print(difference)//output "8 seconds"
            
//            let diff = Calendar.current.dateComponents([.second], from: lastLocation.timestamp, to: location.timestamp).nanosecond
//            let millisecond = diff! * 1000
//            print(millisecond)
         //   let delayTime = lastLocation.timestamp.timeIntervalSince(location.timestamp)
            
//            let interval = Int(delayTime)
//                let seconds = interval / 60
//                let secondsDescrp = String(format: "%02d", seconds)
//            let formatter = DateComponentsFormatter()
//            formatter.allowedUnits = [.second, .second]
//            let time = formatter.string(from: delayTime)
//            SessionManager.shared.lastLocationTime = "No last location \(Date())"

          //  print("✋ \(time)")
//            if location.coordinate.latitude == 0.0 && location.coordinate.longitude == 0 { // print("💛 if location.coordinate.latitude == 0.0 && location.coordinate.longitude == 0 { return }");
//                           return }
            
        /*
            if self.isFilterActive == false {
                
                if NetworkManager.shared.isNetworkAvailable == false  || SocketIOManager.sharedInstance.isSocketIOEnabled == false {
                CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: true, isSocketIOEnabled: SocketIOManager.sharedInstance.isSocketIOEnabled, isNetworkAvailable: NetworkManager.shared.isNetworkAvailable)
                } else  {
                     CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: false, isSocketIOEnabled: SocketIOManager.sharedInstance.isSocketIOEnabled, isNetworkAvailable: NetworkManager.shared.isNetworkAvailable)
                }

                SocketIOManager.sharedInstance.createAndSendPayload(locations: locations, succes: { (locationsSocket) in
                                   //Succes
                                   
                               }) { (payload, locationsFromSocketIO) in
                                   //failed
                                   
                                   
                               }
                
            } else {

             */
                
            //Geofancing
            
//            if NaavSystemEnvironment.currentEntenvironment == .prod { //change to true
//                if IndoorMapsManager.shared.isLocationInsideVenue(location.coordinate) {
//                    print("🧑‍🎤 insite")
//                } else {
//                    print("🧑‍🎤 outsite")
//                   // GeofancingManager.incrementCounter()
//
//                }
//            }
//
            

         //   let distance = LocationManager.sharedInstance.distance(lastLocation, point2: location)
                /* Filter

            if distance < 1  ||  distance > 10 {
                
                CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: true, madeForTraceHealing: false, isSocketIOEnabled: SocketIOManager.sharedInstance.isSocketIOEnabled, isNetworkAvailable: NetworkManager.shared.isNetworkAvailable)
               // print("💛  if distance < 1  ||  distance > 10")

                return
            }


            
            if LocationManager.sharedInstance.filterAndAddLocation(location) == false {
                    
                CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: true, madeForTraceHealing: false, isSocketIOEnabled: SocketIOManager.sharedInstance.isSocketIOEnabled, isNetworkAvailable: NetworkManager.shared.isNetworkAvailable)
              // print("💛  if LocationManager.sharedInstance.filterAndAddLocation(location) == false ")

                return
            }
            
*/

            
            
//            print("🏵✅ (\(location.coordinate.latitude), \(location.coordinate.latitude)) horizontalAccuracy \(location.horizontalAccuracy)  verticalAccuracy \(location.verticalAccuracy) speed \(location.speed) speedAccuracy \(location.speedAccuracy)")
            
            
            
//                if NetworkManager.shared.isNetworkAvailable == false && SocketIOManager.sharedInstance.isSocketIOEnabled == false  {
//
//                    CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: true, isSocketIOEnabled: false, isNetworkAvailable: false, delay: deltaTime)
//                    // print("💛 NetworkManager.shared.isNetworkAvailable == false || SocketIOManager.sharedInstance.isSocketIOEnabled == false ")
//                    return
//
//                } else if NetworkManager.shared.isNetworkAvailable == true && SocketIOManager.sharedInstance.isSocketIOEnabled == false  {
//
//                    CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: true, isSocketIOEnabled: false, isNetworkAvailable: true, delay: deltaTime)
//                    // print("💛 NetworkManager.shared.isNetworkAvailable == false || SocketIOManager.sharedInstance.isSocketIOEnabled == false ")
//                    return
//
//                }  else if NetworkManager.shared.isNetworkAvailable == false && SocketIOManager.sharedInstance.isSocketIOEnabled == true  {
//
//                    CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: true, isSocketIOEnabled: true, isNetworkAvailable: false, delay: deltaTime)
//                    // print("💛 NetworkManager.shared.isNetworkAvailable == false || SocketIOManager.sharedInstance.isSocketIOEnabled == false ")
//                    return
//
//                } else if NetworkManager.shared.isNetworkAvailable == true  && SocketIOManager.sharedInstance.isSocketIOEnabled == true {
//
//
//
//                CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: false, isSocketIOEnabled: true, isNetworkAvailable: true, delay: deltaTime)
//              //  print("💛 NetworkManager.shared.isNetworkAvailable  && SocketIOManager.sharedInstance.isSocketIOEnabled")
//
//
//                    //print("🎰 \(locations.first)")
//                    if self.distance != nil {
//                        self.distance! += distance
//                    }
                    
                    //Accelerometer filter
//                    if AccelerometerManager.shared.isDeviceMoving == false {
//                        print("xx")
//                        return }
                    
               //     self.sendToStream(locations: locations, delta: deltaTimeString)
                  
                
//            }
//           }
        
    }
    
    func sendToStream(locations: [CLLocation]) {
        
        SocketIOManager.sharedInstance.createAndSendPayload(locations: locations) { locationsSocket in
            print("🌸 stream")
        } failure: { (payload, locationsFromSocketIO) in
            print("🌸 failed")

        }

    
    }
    
    func calculateLocation() {
        
    }
    
    func didSentStreming( closure:  @escaping streamingClousure) {
        //  self.didStreamThroughtSocketIO = closure
        self.collectionClosures.append(closure)
    }
    
    private func runAllClousures(didStream: Bool, locations: [CLLocation]) {
        for clousure in self.collectionClosures {
            clousure(didStream, locations)
        }
    }
    
    func checkConnection(locations: [CLLocation]) {
        //        if APIManager.validateIfNetworkIsAvailableAndConnectedToWifiAndSSIDsIsInTheDesignatedNetworks() {
        //          //  print("🍀 internet and wifi")
        //        } else {
        //          //  print("💀 No internet and no wifi")
        //            return
        //        }
    }
    
    //    func streamSocketIO(locations: [CLLocation]) {
    //
    //
    //        SocketIOManager.sharedInstance.createAndSendPayload(locations: locations, succes: { [weak self] (locationsSocket) in
    //
    //            self?.runAllClousures(didStream: true, locations: locationsSocket)
    //
    //        }) { [weak self] (payload, locationsFromSocketIO) in
    //
    //
    //            self?.runAllClousures(didStream: false, locations: locationsFromSocketIO)
    //
    //
    //        }
    //    }
    
    
    
    //    func checkLocationPermissions() {
    //        LocationManager.sharedInstance.getLocationPermissionStatus { (status) in
    //            switch status {
    //            case .notDetermined, .restricted, .denied:
    ////                let statusString = PayloadCreator.shared.getLocationPermissionStatus(status: status)
    ////                DocumentManager.shared.createTextWhenLocationPermissionChange(with: statusString)
    //                break;
    //            case .authorizedAlways, .authorizedWhenInUse:
    //                break;
    //            }
    //        }
     //   }
    
    
    
}
