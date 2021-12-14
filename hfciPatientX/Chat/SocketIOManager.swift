//
//  SocketIOManager.swift
//  NovaTrack
//
//  Created by developer on 11/13/19.
//  Copyright © 2019 Paul Zieske. All rights reserved.
//

import UIKit
import SocketIO
import CoreLocation
import NotificationBannerSwift


struct NavvTrackSocketIO {
    
    static var listWithSocketGeolocationEndpointsToSwitchPROD = ListWithPointer(with: [NavvTrackSocketIO.SocketIOEndPoint.productionLocationLocal,
                                                                                       NavvTrackSocketIO.SocketIOEndPoint.productionLocation])
    
    static var listWithSocketGeolocationEndpointsToSwitchSTAGE = ListWithPointer(with: [NavvTrackSocketIO.SocketIOEndPoint.stageLocationLocal,
                                                                                        NavvTrackSocketIO.SocketIOEndPoint.stageLocation])
    
    static var listWithSocketGeolocationEndpointsToSwitchDEV = ListWithPointer(with: [NavvTrackSocketIO.SocketIOEndPoint.devLocationLocal,                                                                                             NavvTrackSocketIO.SocketIOEndPoint.stageLocationLocal])
    
    static var listWithSocketGeolocationEndpointsToSwitchQA = ListWithPointer(with: [NavvTrackSocketIO.SocketIOEndPoint.qaLocationLocal, NavvTrackSocketIO.SocketIOEndPoint.qaLocation])
    
    static var listWithSocketGeolocationEndpointsToSwitchLOCAL = ListWithPointer(with: [NavvTrackSocketIO.SocketIOEndPoint.localLocationLocal, NavvTrackSocketIO.SocketIOEndPoint.localLocation])



    struct SocketIOEndPoint {
        //Chat
        
        static let production = "https://novatrack.hfhs.org/socket.io"
        static let stage = "https://sandbox-hfhs.navvtrak.com/socket.io"
        static let qa = "https://qa-hfhs.navvtrak.com/socket.io"
        static let dev = "https://dev-hfhs.navvtrak.com/socket.io"
        static let local = "http://localhost:3050"

        //Geolocation
        static let productionLocation = "http://socket.navvtrak.com:3011/geolocation"
        static let productionLocationLocal = "http://rhlxnovatrack02.net.hfh.edu:3011/geolocation"
        
        static let stageLocation = "http://dev-hfhs.navvtrak.com:3011/geolocation"
        static let stageLocationLocal = "http://socket-sandbox.navvtrak.com:32011/geolocation"

        static let devLocation = "http://dev-hfhs.navvtrak.com:3013/geolocation"
        static let devLocationLocal = "http://dev-hfhs.navvtrak.com:3011/geolocation"
        
        static let qaLocation = "http://sandbox-hfhs.navvtrak.com:3011/geolocation"
        static let qaLocationLocal = "http://qa-hfhs.navvtrak.com:3011/geolocation"
        
        static let localLocation = "http://dev-hfhs.navvtrak.com:3011/geolocation"
        static let localLocationLocal = "http://localhost:3011/geolocation"
    }
        
    struct SocketIOChatPath {
        // case production = "chat/prod/socket.io"
        static let production = "/chat/socket.io"
        static let stage = "/chat/socket.io"
        static let qa = "/chat/socket.io"
        static let dev = "/chat/socket.io"
        static let local = "/chat/socket.io"

    }
    
    struct SocketIOLocationPath {
        static let production = "/prod/socket.io" // siempre es prod para todos menos en dev
        static let stage = "/dev/socket.io"
    }
    
   // let collectionOfSocketURLsForGeolocationSocketForProd : [SocketIOEndPoint] = [.productionLocation, .devLocation]
}

struct LaheySocketIO {
    
    static var listWithSocketGeolocationEndpointsToSwitchPROD = ListWithPointer(with: [LaheySocketIO.SocketIOEndPoint.productionLocation,
                                                                                       LaheySocketIO.SocketIOEndPoint.productionLocationLocal,
                                                                                       ])
    
    static var listWithSocketGeolocationEndpointsToSwitchSTAGE = ListWithPointer(with: [LaheySocketIO.SocketIOEndPoint.stageLocation])
    
    struct SocketIOEndPoint {
        //Chat // no hay dev en lahey por le momento solo stage
        static let production = "https://navvtrack.lahey.org/dev/socket.io"
        static let stage = "https://lahey.navvtrak.com/dev/socket.io" //change to stage
        
        //Geolocation
        static let productionLocation = "http://navvtrack.lahey.org:3011/geolocation"
        static let productionLocationLocal = "http://socket-lahey.navvtrak.com:32011/geolocation"
        
        static let stageLocation = "http://lahey.navvtrak.com:3011/geolocation"
      
    }
    
    struct SocketIOChatPath {
        // case production = "chat/prod/socket.io"
        static let stage = "/chat/socket.io"
    }
    
    struct SocketIOLocationPath {
        // case production = "/prod/socket.io"
        static let dev = "/dev/socket.io"
    }
}

struct SocketIOEnvoriment {
    
        
    static func getPathLocation() -> String {
        let selectedhospitalName = SettingsBundleHelper.shared.selectedHospital
        let hospitalWithEnvironment = NaavSystemEnvironment[Hospital(rawValue: selectedhospitalName.rawValue) ?? .other]

        switch  hospitalWithEnvironment.name {
        
        case .henryford:
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return NavvTrackSocketIO.SocketIOLocationPath.stage
            case .staging:
                return NavvTrackSocketIO.SocketIOLocationPath.stage
            case .qa:
                return NavvTrackSocketIO.SocketIOLocationPath.stage
            case .prod:
                return NavvTrackSocketIO.SocketIOLocationPath.production
            case .local:
                return NavvTrackSocketIO.SocketIOLocationPath.stage
            }

           // return SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.SocketIOLocationPath.production.rawValue :  NavvTrackSocketIO.SocketIOLocationPath.sandbox.rawValue
            
            
        case .lahey:
            
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return LaheySocketIO.SocketIOLocationPath.dev
            case .staging:
                return LaheySocketIO.SocketIOLocationPath.dev
            case .qa:
                return LaheySocketIO.SocketIOLocationPath.dev
            case .prod:
                return LaheySocketIO.SocketIOLocationPath.dev
            case .local:
                return LaheySocketIO.SocketIOLocationPath.dev
            }
           
        // return SettingsBundleHelper.shared.isProductionEnabled ? LaheySocketIO.SocketIOLocationPath.sandbox.rawValue :  LaheySocketIO.SocketIOLocationPath.sandbox.rawValue
            
        case .other:
            
          return ""
           // return SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.SocketIOLocationPath.production.rawValue :  NavvTrackSocketIO.SocketIOLocationPath.sandbox.rawValue
        }
    }
    
    static func getPathChat() -> String {
        
        let selectedhospitalName = SettingsBundleHelper.shared.selectedHospital
        let hospitalWithEnvironment = NaavSystemEnvironment[Hospital(rawValue: selectedhospitalName.rawValue) ?? .other]

        switch  hospitalWithEnvironment.name {
        case .henryford:
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return NavvTrackSocketIO.SocketIOChatPath.stage
            case .staging:
                return NavvTrackSocketIO.SocketIOChatPath.stage
            case .qa:
                return NavvTrackSocketIO.SocketIOChatPath.stage
            case .prod:
                return NavvTrackSocketIO.SocketIOChatPath.stage
            case .local:
                return NavvTrackSocketIO.SocketIOChatPath.stage
            }
           // return SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.SocketIOChatPath.sandbox.rawValue :  NavvTrackSocketIO.SocketIOChatPath.sandbox.rawValue
            
        
        case .lahey:
            //return SettingsBundleHelper.shared.isProductionEnabled ? LaheySocketIO.SocketIOChatPath.sandbox.rawValue :  LaheySocketIO.SocketIOChatPath.sandbox.rawValue
            switch hospitalWithEnvironment.environment {
            case .dev:
                return LaheySocketIO.SocketIOChatPath.stage
            case .staging:
                return LaheySocketIO.SocketIOChatPath.stage
            case .qa:
                return LaheySocketIO.SocketIOChatPath.stage
            case .prod:
                return LaheySocketIO.SocketIOChatPath.stage
            case .local:
                return LaheySocketIO.SocketIOChatPath.stage
            }
            
        case .other:
            // return SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.SocketIOChatPath.sandbox.rawValue :  NavvTrackSocketIO.SocketIOChatPath.sandbox.rawValue
            return NavvTrackSocketIO.SocketIOChatPath.stage
        }
    }
    
    static func getEnvorimentChat() -> String {
        let selectedhospitalName = SettingsBundleHelper.shared.selectedHospital
        let hospitalWithEnvironment = NaavSystemEnvironment[Hospital(rawValue: selectedhospitalName.rawValue) ?? .other]

        switch  hospitalWithEnvironment.name {
       
        case .henryford:
           // return SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.SocketIOEndPoint.production.rawValue : NavvTrackSocketIO.SocketIOEndPoint.sandbox.rawValue
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return NavvTrackSocketIO.SocketIOEndPoint.dev
            case .staging:
                return NavvTrackSocketIO.SocketIOEndPoint.stage
            case .qa:
                return NavvTrackSocketIO.SocketIOEndPoint.qa
            case .prod:
                return NavvTrackSocketIO.SocketIOEndPoint.production
            case .local:
                return NavvTrackSocketIO.SocketIOEndPoint.local
            }
            
        case .lahey:
          //  return SettingsBundleHelper.shared.isProductionEnabled ? LaheySocketIO.SocketIOEndPoint.production.rawValue : LaheySocketIO.SocketIOEndPoint.sandbox.rawValue
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return LaheySocketIO.SocketIOEndPoint.stage
            case .staging:
                return LaheySocketIO.SocketIOEndPoint.stage
            case .qa:
                return LaheySocketIO.SocketIOEndPoint.stage
            case .prod:
                return LaheySocketIO.SocketIOEndPoint.production
            case .local:
                return LaheySocketIO.SocketIOEndPoint.stage
            }
            
        case .other:
           // return SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.SocketIOEndPoint.production.rawValue : NavvTrackSocketIO.SocketIOEndPoint.sandbox.rawValue
        return NavvTrackSocketIO.SocketIOEndPoint.dev
        }
    }
    
    
    static func getEnvorimentLocation() -> String {
        let selectedhospitalName = SettingsBundleHelper.shared.selectedHospital
        let hospitalWithEnvironment = NaavSystemEnvironment[Hospital(rawValue: selectedhospitalName.rawValue) ?? .other]

        switch  hospitalWithEnvironment.name {
        case .henryford:
         //   return SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.SocketIOEndPoint.productionLocationLocal.rawValue : NavvTrackSocketIO.SocketIOEndPoint.stageLocationLocal.rawValue
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return NavvTrackSocketIO.SocketIOEndPoint.devLocation
            case .staging:
                return NavvTrackSocketIO.SocketIOEndPoint.stageLocationLocal
            case .qa:
                return NavvTrackSocketIO.SocketIOEndPoint.qaLocationLocal
            case .prod:
                return NavvTrackSocketIO.SocketIOEndPoint.productionLocationLocal
            case .local:
                return NavvTrackSocketIO.SocketIOEndPoint.local
            }
            
        case .lahey:
          //  return SettingsBundleHelper.shared.isProductionEnabled ? LaheySocketIO.SocketIOEndPoint.productionLocation.rawValue : LaheySocketIO.SocketIOEndPoint.stageLocation.rawValue
            
            switch hospitalWithEnvironment.environment {
            case .dev:
                return LaheySocketIO.SocketIOEndPoint.stageLocation
            case .staging:
                return LaheySocketIO.SocketIOEndPoint.stageLocation
            case .qa:
                return LaheySocketIO.SocketIOEndPoint.stageLocation
            case .prod:
                return LaheySocketIO.SocketIOEndPoint.productionLocation
            case .local:
                return LaheySocketIO.SocketIOEndPoint.stageLocation
            }
            
        case .other: // By default HenryFord
            //  return SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.SocketIOEndPoint.productionLocation.rawValue : NavvTrackSocketIO.SocketIOEndPoint.devLocation.rawValue
        return NavvTrackSocketIO.SocketIOEndPoint.stageLocationLocal
        }
        
    }
    
    
    static var envorimentSocketChat: String {
        get {
            SocketIOEnvoriment.getEnvorimentChat()
        }
    }
    
    static var pathSocketChat: String {
        get {
            SocketIOEnvoriment.getPathChat()
        }
    }
    
    static var pathSocketLocation: String {
        get {
            SocketIOEnvoriment.getPathLocation()
        }
    }
    
    static var envorimentSocketLocation: String {
        get {

           return SocketIOEnvoriment.getEnvorimentLocation()
        }
    }
    
    //    static var envoriment: String {
    //        get {
    //            return SettingsBundleHelper.shared.isProductionEnabled ? SocketIOEndPoint.production.rawValue :  SocketIOEndPoint.sandbox.rawValue
    //        }
    //    }
    
    //    static var localEnvoriment: String {
    //        get {
    //            SocketIOEndPoint.local.rawValue
    //        }
    //    }
    
}

class SocketIOManager: NSObject {
    
    
    static let sharedInstance = SocketIOManager()
    // var envoriment = SocketIOEndPoint()
  //  var manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketLocation)!, config: [.log(true), .secure(false), .reconnectWait(5), .security(SSLSecurity(usePublicKeys: false)), .forceWebsockets(true)])
  //  var manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketLocation)!, config: [.log(false), .secure(false), .reconnectWait(5), .security(SSLSecurity(usePublicKeys: false)), .compress, .forceWebsockets(true)])
    
    var manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketLocation)!, config: [.log(false), .secure(false), .reconnectWait(5), .security(SSLSecurity(usePublicKeys: false)), .compress, .forceWebsockets(true)])

    var socket: SocketIOClient!
  
    //  private var socketMessages: SocketIOClient!
    var reconnectionAttempts = 0 {
        didSet {
            if reconnectionAttempts == 5 {
                let selectedhospitalName = SettingsBundleHelper.shared.selectedHospital
                let hospitalWithEnvironment = NaavSystemEnvironment[Hospital(rawValue: selectedhospitalName.rawValue) ?? .other]

                switch  selectedhospitalName {
                case .henryford:
                   
                 //   print("🍀⚽️ from \(self.manager.socketURL)")
                   
                  
                    var newUrl = ""
                    switch hospitalWithEnvironment.environment {
                    case .dev:
                        NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchDEV.incrementPointer()
                        newUrl = NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchDEV.getPointerElement()
                    case .staging:
                        NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.incrementPointer()
                        newUrl = NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.getPointerElement()
                    case .qa:
                        NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchQA.incrementPointer()
                        newUrl = NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchQA.getPointerElement()
                    case .prod:
                        NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchPROD.incrementPointer()
                        newUrl = NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchPROD.getPointerElement()
                    case .local:
                        NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchLOCAL.incrementPointer()
                        newUrl = NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchLOCAL.getPointerElement()
                    }
                    
                 //   SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchPROD.incrementPointer() : NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchQA.incrementPointer()
                    
//                    let newUrl = SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchPROD.getPointerElement() :  NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.getPointerElement()
                    
                    self.manager = SocketManager(socketURL: URL(string: newUrl)!, config: [.log(false), .secure(false), .reconnectWait(5), .security(SSLSecurity(usePublicKeys: false)), .compress, .forceWebsockets(true)])
                   
                    reconnectionAttempts = 0
                    self.setup()
               //     playSound()
                  //  Alerts.displayAlert(with: "SocketIO Switch", and: "\(newUrl)")
                //    print("🍀⚽️ to \(self.manager.socketURL)")
                    
                case .lahey:
                    
                    var newUrl = ""
                    switch hospitalWithEnvironment.environment {
                    case .dev:
                        LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.incrementPointer()
                        newUrl = LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.getPointerElement()
                    case .staging:
                        LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.incrementPointer()
                        newUrl = LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.getPointerElement()
                    case .qa:
                        LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.incrementPointer()
                        newUrl = LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.getPointerElement()
                    case .prod:
                        LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchPROD.incrementPointer()
                        newUrl = LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchPROD.getPointerElement()
                    case .local:
                        LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.incrementPointer()
                        newUrl = LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.getPointerElement()
                    }
                   
//                    SettingsBundleHelper.shared.isProductionEnabled ? LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchPROD.incrementPointer() : LaheySocketIO.listWithSocketGeolocationEndpointsToSwitchSTAGE.incrementPointer()
//
//
//                    let newUrl = SettingsBundleHelper.shared.isProductionEnabled ? NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchPROD.getPointerElement() :  NavvTrackSocketIO.listWithSocketGeolocationEndpointsToSwitchDEV.getPointerElement()
                    
                    self.manager = SocketManager(socketURL: URL(string: newUrl)!, config: [.log(false), .secure(false), .reconnectWait(5), .security(SSLSecurity(usePublicKeys: false)), .compress, .forceWebsockets(true)])
                   
                    reconnectionAttempts = 0
                    self.setup()
                  //  playSound()
                  //  Alerts.displayAlert(with: "SocketIO Switch", and: "\(newUrl)")
                case .other: // By default HenryFord
                     break
                }
                
               

            }
        }
    }
    var isSocketIOEnabled = false
    var isSocketIOLocationEnabled = "NO STATUS" {
        didSet {
            if oldValue == "NO STATUS" {
                print("🍀💩 Status didSet")
                //                           if self.socket.status != .connected {
                //                            print("🍀💩 Status didSet try recoonect")
                self.manager.reconnect()
                self.socket.connect()
                //                           }
               // CoreDataManager.sharedInstance.addAppState(state: "Status willSet")
                
            }
        }
        
        willSet {
            if newValue == "NO STATUS" {
                print("🍀💩 Status willSet")
                // if self.socket.status != .connected {
                print("🍀💩 Status willSet try recoonect")
                self.manager.reconnect()
                self.socket.connect()
             //   CoreDataManager.sharedInstance.addAppState(state: "Status willSet")
                
                // }
            }
        }
    }
    
    
    private override init() {
        super.init()
        
        //        self.socket = manager.socket(forNamespace: "/geolocation")
        //        addHandlers()
        //        addListeners()
        //        connectionStatusHandler()
//        print("🍀🦷 location init url: \(SocketIOEnvoriment.envorimentSocketChat)")
//        print("🍀🦷 location init path:\(SocketIOEnvoriment.pathSocketChat)")
        setup()
       
        
    }
    
    deinit {
        self.isSocketIOLocationEnabled = "💩 Singleton denit"
    }
    
    func setup() {
        print("🍀🦷 location setup init url: \(SocketIOEnvoriment.envorimentSocketLocation)")
        print("🍀🦷 location setup init path:\(SocketIOEnvoriment.pathSocketLocation)")
        self.socket = manager.socket(forNamespace: "/geolocation")
        self.manager.reconnects = true
        
        addHandlers()
        addListeners()
        connectionStatusHandler()
        self.establishConnection()
    }
    
    //    func switchSocketIOEnvoriment(isProduction: Bool) {
    //        self.envoriment = isProduction ? .production : .sandbox
    //    }
    
    private func connectionStatusHandler() {
        // var didUpdateLocation = false
        NetworkManager.shared.networkDidchange { [weak self] (isNetworkAvailable) in
            // didUpdateLocation = true
            //if didUpdateLocation == false {
            //  if isNetworkAvailable == false {
          //  ChunkIdCreator.incrementChunkId()
            // didUpdateLocation = false
            // }
            //  }
            self?.manager.reconnect()

        }
    }
    
    func switchEnvoriment() {
        // self.manager.config = [.log(false), .secure(true), .forceNew(true), .reconnectWait(5), .security(SSLSecurity(usePublicKeys: true)), .compress, .path(SocketIOEnvoriment.pathSocketLocation)]
//        print("🍀🦷 location switch init url: \(SocketIOEnvoriment.envorimentSocketChat)")
//        print("🍀🦷 location switch init path:\(SocketIOEnvoriment.pathSocketChat)")
        print("🍀 🚨 start switch to \(SocketIOEnvoriment.envorimentSocketLocation)")
        
        
        self.closeConnection()
      //  self.manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketLocation)!, config: [.log(false), .secure(false), .forceNew(true), .reconnectWait(5), .security(SSLSecurity(usePublicKeys: false)), .compress])
        
        self.manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketLocation)!, config: [.log(false), .secure(false), .reconnectWait(5), .security(SSLSecurity(usePublicKeys: false)), .compress, .forceWebsockets(true)])

        self.setup()
       // self.establishConnection()
        
        print("🍀 🚨 finish switch")
        
    }
    
    func addHandlers() {
        
        
        
        socket.on(clientEvent: .connect) { [weak self] (data, ack) in
            
            print(data)
            print(ack)
            print(ack.rawEmitView)
            // print(ack.)
          //  print("🍀 ✅ location socket id \(self?.socket.sid)")
            
            
            let description = "\(true) connect status:\(String(describing: self?.socket.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            print("🍀 ✅ | socketURL: \(String(describing: self?.manager.socketURL)) | socketId:  \(String(describing: self?.socket.sid))) |  envoriments: \(SocketIOEnvoriment.envorimentSocketLocation) | path: \(SocketIOEnvoriment.pathSocketLocation)  | location \(description)")
            
            self?.isSocketIOEnabled = true
            self?.isSocketIOLocationEnabled = description
            self?.reconnectionAttempts = 0
          //  playSuccesSound()
            
        //    self?.uploadLocationAccessDenied(status: PayloadCreator.shared.getCurrentLocationPermissionStatus())
           
            
            var stateString = ""
            let state = UIDevice.current.batteryState
            
            switch state {
            case  .unknown:
                stateString = "unknown"
            case .unplugged:
                stateString = "unplugged"
            case .charging:
                stateString = "charging"
            case .full:
                stateString = "full"
            @unknown default:
                stateString = "no info"
            }

         //   self?.uploadBatteryState(state: stateString)
            
            
            let batteryLvl = UIDevice.current.batteryLevel
         let porcentage = batteryLvl * 100
         print("🧩 \(porcentage)")
       //  self?.uploadBatteryPorcentage(porcentage: String(porcentage))

        //    self?.succesBanner()
            
        }
        
        socket.on(clientEvent: .error) { [weak self] (data, ack) in
            
            
            let description = "\(false) error status:\(String(describing: self?.socket.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            print("🍀💚 location \(description)")
            
            self?.isSocketIOEnabled = false
            
            self?.isSocketIOLocationEnabled = description
            
            self?.manager.reconnect()
         //   playNoSocket()

        }
        
        socket.on(clientEvent: .disconnect) { [weak self] (data, ack) in
            
            let description = "\(false) disconnect status:\(String(describing: self?.socket.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            
            print("🍀 location \(description)")
            
            self?.isSocketIOEnabled = false
            self?.isSocketIOLocationEnabled = description
            
            //  self.socketMessages.disconnect()
            self?.socket.disconnect()
           // self?.dangerBanner()
          //  playNoSocket()
        }
        
        socket.on(clientEvent: .statusChange) { [weak self] (data, ack) in
            let description = "statusChange status:\(String(describing: self?.socket.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            print("🍀 location \(description)")
            if self?.socket.status != .connected {
                self?.isSocketIOEnabled = false
              //  playNoSocket()

            }
        }
        
        
        
        
        
        
        
//        socket.connect(timeoutAfter: 60.0) {
//            let description = "timeoutAfter: 60.0 status:\(String(describing: self.socket.status)) date:\(Date().stringFromDateZuluFormat())"
//            print("🍀 location \(description)")
//        }
        
        socket.on(clientEvent: .reconnect) { [weak self] (data, ack) in
            let description = "\(false) reconnect status:\(String(describing: self?.socket.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            print("🍀 location reconnect \(description)")
            
            self?.isSocketIOLocationEnabled = description
            
        }
        
        socket.on(clientEvent: .reconnectAttempt) { [weak self] (data, ack) in
            let description = "\(false) reconnectAttempt status:\(String(describing: self?.socket.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            print("🍀 location \(description)")
            
            self?.isSocketIOLocationEnabled = description
            self?.reconnectionAttempts += 1
            
        }
        
        socket.on(clientEvent: .ping) { [weak self] (data, ack) in
            
            let description = "ping location status:\(String(describing: self?.socket.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
        //    print("🍀🏓 \(description)")
            //self?.socket.status
            self?.isSocketIOLocationEnabled = description
            
            if self?.socket.status == .disconnected {
                self?.socket.connect()
            }
            //  self?.manager.reconnect()
            
        }
        
        socket.on(clientEvent: .pong) { [weak self] (data, ack) in
            
            let description = "pong location status:\(String(describing: self?.socket.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
        //    print("🍀🏓 \(description)")
            //   self?.manager.reconnect()
            self?.isSocketIOLocationEnabled = description
            
            if self?.socket.status == .disconnected {
                self?.socket.connect()
            }
            
        }
        
        
    }
    
    func addListeners() {
        
        
        socket.on("HFHTransport-1-susbcribe") { [weak self] (data, ack) in
          //  print(data)
            SessionManager.shared.checkIncomingMessageToTerminateSession(data: data)
            //  SessionManager.shared.checkIncomingMessageToGetJobId(data: data)
        //    CoreDataManager.sharedInstance.checkIncomingMessageToHanldeUploadOfTotalLogsInCurrentJob(data: data)
            
           
            
        }
        
        
        //Confirmation geolocation
        socket.on("HFHTransport-1-susbcribe") { (data, ack) in
            
            
            
            //                guard let array = object as? Array<Any> else { return }
            //                      guard let dict = array.first as? [String: Any] else { return }
            //                      guard let logId = dict.valueForKeyPath(keyPath: "log_id") as? Int else { return }
            
         //   guard let logId = self?.parseLogId(object: object) else { return failure() }
            
            
            
            
            
            
            guard let responce: [String: Any] = data.first as? [String : Any] else { return  }
          //  print(responce)
            guard let type = responce.valueForKeyPath(keyPath: "type") as? String else { return }
            
            if type == MessagesTypes.geolocation.rawValue {
               // print(responce)
                
                if let dictionary = responce.valueForKeyPath(keyPath: "message") as? [String : Any], let userId = dictionary.valueForKeyPath(keyPath: "user_id") as? String, let logIdResponce = dictionary.valueForKeyPath(keyPath: "log_id") as? Int, let logStored = dictionary.valueForKeyPath(keyPath: "logStored") as? Bool {
                    if userId == SessionManager.shared.user?.userId  { // &&  logId == logIdResponce {
                        
                        
//                        if self?.repetedLogId == logId && self?.repetedUserId == userId {
//                            print("🍀❤️❤️❤️💛 if self?.repetedLogId == logId && self?.repetedUserId == userId \(Date().stringFromDate()) logId: \(logId) userIdResponce: \(userId) \(String(describing: SessionManager.shared.user?.userId))")
//
//                            failure()
//                        }
//
//                        self?.repetedLogId = logId
//                        self?.repetedUserId = userId
                        //here is the confimratin for sending geolocation
                        
                        
                  //      print("🍀❤️❤️❤️ log id responce \(logIdResponce)")
                        
                        if logStored {
                            //  CoreDataManager.sharedInstance.addTrace(sentToBackend: true, locations: locations, discarded: false)
//                            print("🍀❤️❤️❤️❤️ Confirmation sent \(Date().stringFromDate()) logId: \(logId) userIdResponce: \(userId) \(String(describing: SessionManager.shared.user?.userId))")
                            
//                            CoreDataManager.sharedInstance.updateLogItem(id: logIdResponce.description, sent: true) { [logIdResponce] (succes) in
//                                if succes {
//                                    print("🐼💛🤍❤️🏆 logId: \(logIdResponce)")
//                                   // LocationStreaming.sharedInstance.isFilterActive = true
//                                    LocationStreaming.sharedInstance.isFilterActive = true
//                                }
//                            }
//                            timer2?.invalidate()
//
//                            succes()
//                        } else {
//                            timer2?.invalidate()
//                            failure()
//                        }
//
//
//
//                    } else {
//                        timer2?.invalidate()
//                        return failure()
//                    }
//
//                } else {
//                    timer2?.invalidate()
//                    return failure()
//                }
//            } else {
//                timer2?.invalidate()
//                return failure()
//            }
            
        }
                    }
                }
        
            }
        }
        
        
        //Trace healing listener
        socket.on("HFHTransport-1-susbcribe") { (data, ack) in
            
            guard let responce: [String: Any] = data.first as? [String : Any] else {
                //   timer2?.invalidate()
                //  return failure()
                return
            }
            //   print(responce)
            guard let type = responce.valueForKeyPath(keyPath: "type") as? String else {
                //                           timer2?.invalidate()
                //                           return failure()
                return
            }
            
            if type == MessagesTypes.history.rawValue {
                
                // print("🧠⛑ \(responce)")
                
                
                if let dictionary = responce.valueForKeyPath(keyPath: "message") as? [String : Any], let userId = dictionary.valueForKeyPath(keyPath: "user_id") as? String, let logIdResponse = dictionary.valueForKeyPath(keyPath: "log_id") as? Int, let logStored = dictionary.valueForKeyPath(keyPath: "logStored") as? Bool {
                    
                    if userId == SessionManager.shared.user?.userId { //&& logItem.id == logIdResponse.description {
                        
                        //  if !logStored { failure() }
                        if logStored {
                           // let logItemId = Int(logIdResponse)
                            // if self.repetedLogIdTraceHealing == logIdResponse && self.repetedLogIdTraceHealing == logItemId { return }
                            //  if self.repetedLogIdTraceHealing == logIdResponse && self.repetedLogIdTraceHealing == logItemId { return }
                            
                            //   self.repetedLogIdTraceHealing = logIdResponse
                            // succes(logItem)
                            
//                            CoreDataManager.sharedInstance.updateLogItem(id: logIdResponse.description, sent: true) { (succes) in
//                                                   if succes  {
//                                                   //   print("💛🧠🧠 Succes \(String(describing: logIdResponse))")
//
//                                                       }
//
//                                                    //   print("🎃 longitude:\(logItem.longitude ?? "n/a"), latitude:\(logItem.longitude ?? "n/a"), isNetworkAvailable:\(logItem.isNetworkAvailable). jobId:\(logItem.jobId ?? "n/a"), createdDate:\(String(describing: logItem.date) )")
//
//
//                                                   }
//                                                //   self?.isUploading = false
//
//                                               }
//
                            //                                   } else {
                            //                                       timer2?.invalidate()
                            //                                       failure()
                            //                                   }
                            //                               } else {
                            //                                   timer2?.invalidate()
                            //                                   failure()
                            //                               }
                            //
                            //                           } else {
                            //                               timer2?.invalidate()
                            //                               failure()
                            //                           }
                            //
                            //                       } else {
                            //                           timer2?.invalidate()
                            //                           failure()
                            //                       }
                        }
                        
                        
                    }
                }
                
            }
            
    
        }
    }
        
    
    
    func establishConnection() {
        socket.connect()
        manager.connect()
        //  socketMessages.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
        manager.disconnect()
        //   socketMessages.disconnect()
    }
    
    @available(iOS 13.4, *)
    func createAndSendPayload(locations: [CLLocation], succes: @escaping ([CLLocation])->(), failure: @escaping ([String: Any], [CLLocation])->()) {
        //if shortpayload or long payload
      //  let socketIOPayload = PayloadCreator.shared.createPayload(for: .socketIO, with: locations, and: nil)
    //    let shortSocketIOPayload = PayloadCreator.shared.createShortPayload(for: .socketIO, with: locations, and: nil)
        let socketIOPayload = JobManager.shortPayload ? PayloadCreator.shared.createPayload(for: .socketIO, with: locations, delta: "", and: nil) : PayloadCreator.shared.createShortPayload(for: .socketIO, with: locations, delta: "", and: nil)
         print("💠socketIOPayload \(socketIOPayload)")
        //  PayloadCreator.shared.printPayload(payload: socketIOPayload)

        let payloadArray: [[String:Any]] = [socketIOPayload]
        //  print("🍀🎲 payload: \(payloadArray)")
      //  print("🍀 5 Payload created \(payloadArray)")

        // Poner bandera para no subir si esta ocupado

        self.sendLocationPayload(object: payloadArray, locations: locations, succes: { [locations] in
            // print("👹 payload socketIOPayload: \(socketIOPayload)")

            // print("🥰🥰  log id: \(String(describing: locations.first?.value(forKey: "id")))  sentToBackend: \(String(describing: locations.first?.value(forKey: "sentToBackend"))) ")
            //print("🥰🥰")

            succes(locations)
        }) {

            // print("🍀 8 failure trace sent")

            failure(socketIOPayload, locations)
        }
    }
    
    var repetedLogId: Int = 0
    var repetedUserId: String = ""
    var repetedLogIdTraceHealing: Int = 0
    
    func parseLogId(object: Any) -> Int? {
        guard let array = object as? Array<Any> else { return nil }
        guard let dict = array.first as? [String: Any] else { return nil}
        guard let logId = dict.valueForKeyPath(keyPath: "log_id") as? Int else { return nil}
        return logId
    }
    
    func parseCoordinates(object: Any) -> [String: Any]? {
          guard let array = object as? Array<Any> else { return nil }
          guard let dict = array.first as? [String: Any] else { return nil}
        guard let geolocation = dict.valueForKeyPath(keyPath: "geolocation") as? [String: Any] else { return nil}
          return geolocation
      }
    
    
    
    @available(iOS 13.4, *)
    func sendLocationPayload(object: Any, locations: [CLLocation], succes: @escaping ()->(), failure: @escaping ()->()) {
        
        //        guard let array = object as? Array<Any> else { return }
        //                             guard let dict = array.first as? [String: Any] else { return  }
        //                             guard let logId = dict.valueForKeyPath(keyPath: "log_id") as? Int else { return }
        //
//        guard let logId = parseLogId(object: object) else { return failure() }
//        print("🍀❤️ sendLocationPayload with logId \(logId)")
        
        //   print(logId)
        //  print(array)
        
        
      //  print("🍀 6 Uploading function")
        
        
        
        
        //        func fireTimer() {
        //            print("Timer fired!")
        //        }
        //
        //        let function: () = fireTimer()
        //        let timer1 = Timer.scheduledTimer(timeInterval: 5.0, target: function, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        
       if socket.status == .connected {
        
       // print("💛  if socket.status == .connected")

//            //    var timer: Timer?
//            // // print(".connected")
//            //  socketMesages.emit("geolocation-channel", with: [object])
//            var timer2: Timer?
  //      let _: Timer? =  Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
//                print("🍀 7.1 timer 1 fired trace sent to trace healing \(Date().stringFromDate()) logId: \(logId)")
//                print("🍀❤️🤍 Location sent to trace healing \(Date().stringFromDate()) logId: \(logId)")
//                CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: true)
         //       failure()

    //    }
         
            socket.emit("geolocation-channel", with: [object]) { [weak self] in
                
                        //      print(object)
                //                guard let array = object as? Array<Any> else { return }
                //                                            guard let dict = array.first as? [String: Any] else { return }
                //                                            guard let logId = dict.valueForKeyPath(keyPath: "log_id") as? Int else { return }
//                guard let logId = self?.parseLogId(object: object) else { return }
//                guard let geolocation = self?.parseCoordinates(object: object) else { return }
              print("🍀❤️❤️ emit  succes")
                //  timer.fire()
               // print("💛💛🐼💚 emit logid:\(logId) geolocation: \(geolocation)")
               // print("💛🤍 emit logid:")

              //  CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: false)
                
            //    timer1?.invalidate()
                //                CoreDataManager.sharedInstance.addTrace(sentToBackend: true, locations: locations)
                succes()
                
//               timer2 =  Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
////                    print("🍀 7.1 timer 2 fired trace sent to trace healing \(Date().stringFromDate()) logId: \(logId)")
////                    print("🍀❤️🤍 Location sent to trace healing \(Date().stringFromDate()) logId: \(logId)")
////                    CoreDataManager.sharedInstance.addTrace(sentToBackend: false, locations: locations, discarded: false, madeForTraceHealing: true)
////
//                      failure()
//
//                }
                
            }
            
            
       } else if self.socket.status != .connected {
        print("💛 else if socket.status != .connected")

           // print("🍀💚 Socket-io socket.status == .disconnected || socket.status == .notConnected \(Date().stringFromDate())")
            failure()
        }
        
    }
    
    
//    func uploadLogToBackendForTraceHealing(object: Any, succes: @escaping ()->(), fail failure: @escaping ()->()) {
//
//        guard let logItemArray = object as? [LogItem], let logItem = logItemArray.first else {
//            failure()
//            return
//        }
//
//        let objectArray = [logItem.getFormattedLogForTraceHealing()]
//        print("traceHealing object \(objectArray)")
//
//        //        self.socket.on(clientEvent: .error) { [logItem] (data, ack) in
//        //            print("🧠 Failure uploading trace id:\(String(describing: logItem.id))")
//        //            failure()
//        //        }
//
//        //socket.accessibilityActivate()
//
//        if self.socket.status == .connected {
//
//            //            self.socket.connect(timeoutAfter: 5.0) {
//            //                failure()
//            //
//            //            }
//
//
//
//            //            self.socket.emitWithAck("History-channel", with: objectarray).timingOut(after: 5.0) { (data) in
//            //                print("🧠 \(data)")
//            //            }
//
//
////            var timer2: Timer?
////            let timer1: Timer? =  Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
////
////                failure()
////
////            }
//
//            // You can specify a custom timeout interval. 0 means no timeout.
//
//
//
//
//
//            self.socket.emit("History-channel", with: objectArray) {
//
//                print("🧑‍🎤🧠✅ trace healing: \(self.manager.socketURL)")
////            guard let array = object as? Array<Any> else { return }
////            guard let logitem = array.first as? LogItem else { return  }
//       //     print("💛🧠✅ Healing id:\(String(describing: logitem.id!))")
//
////                timer1?.invalidate()
////
////
////                timer2 =  Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
////
////                    failure()
//
//
//            succes()
//
//                }
//            }
//
////            socket.on("HFHTransport-1-susbcribe") { [logItem] (data, ack) in
////
////                guard let responce: [String: Any] = data.first as? [String : Any] else {
////                    timer2?.invalidate()
////                    return failure()
////                }
////                //   print(responce)
////                guard let type = responce.valueForKeyPath(keyPath: "type") as? String else {
////                    timer2?.invalidate()
////                    return failure()
////                }
////
////                if type == MessagesTypes.history.rawValue {
////
////                    // print("🧠⛑ \(responce)")
////
////
////                    if let dictionary = responce.valueForKeyPath(keyPath: "message") as? [String : Any], let userId = dictionary.valueForKeyPath(keyPath: "user_id") as? String, let logIdResponse = dictionary.valueForKeyPath(keyPath: "log_id") as? Int, let logStored = dictionary.valueForKeyPath(keyPath: "logStored") as? Bool {
////
////                        if userId == SessionManager.shared.user?.userId  && logItem.id == logIdResponse.description {
////
////                            //  if !logStored { failure() }
////                            if logStored {
////                                let logItemId = Int(logItem.id!)
////                                if self.repetedLogIdTraceHealing == logIdResponse && self.repetedLogIdTraceHealing == logItemId { return }
////
////                                self.repetedLogIdTraceHealing = logIdResponse
////                                print("💛🧠🧠 Succes \(String(describing: logIdResponse))")
////                                succes(logItem)
////
////                            } else {
////                                timer2?.invalidate()
////                                failure()
////                            }
////                        } else {
////                            timer2?.invalidate()
////                            failure()
////                        }
////
////                    } else {
////                        timer2?.invalidate()
////                        failure()
////                    }
////
////                } else {
////                    timer2?.invalidate()
////                    failure()
////                }
////            }
//         else if socket.status != .connected {
//         //   print("🧠 \(self.socket.status)")
//          //  print("💛⛑☠️ Healing Failure Emiting \(String(describing: logItem.id))")
//            failure()
//        }
//
//
//}
    
//    func uploadTotalAmountOfLogsInJob() {
//
//
//        let params = ["userId": SessionManager.shared.user?.userId ?? "", "totalLogsInJob": CoreDataManager.sharedInstance.totalLogsCountInJobNotDiscarded ?? 0, "jobId": JobManager.jobId ?? "", "jobHasTraceHealing": CoreDataManager.sharedInstance.totalNotSentLogsCountInJob ?? -1] as [String : Any]
//        print("🧑‍🎤 \(params)")
//
//        self.socket.emit("Total-Logs", with: [params]) {
//            //  // // print("log sent")
//            print("🧑‍🎤 Total-Logs sent")
//
//            //   JobManager.jobId = nil
//
//        }
//
//
//
//    }
    
    func uploadLocationAccessDenied(status: String) {
        let params = ["type": "location-settings", "locationAccess": status, "deviceId": SettingsBundleHelper.shared.deviceID ?? "no device id", "userId": SessionManager.shared.user?.userId ?? "no user id"]
        let message = ["message": params]
        print("🧑‍🎤 \(params)")
        self.socket.emit("Settings-channel", with: [message]) {
            print("🧑‍🎤 location-settings sent")
        }
    }
    
    func uploadBatteryState(state: String) {
        let params = ["type": "batteryState", "batteryState": state, "deviceId": SettingsBundleHelper.shared.deviceID ?? "no device id", "userId": SessionManager.shared.user?.userId ?? "no user id"]
        let message = ["message": params]
        print("🧑‍🎤 \(params)")
       // let messagetest = []
        self.socket.emit("Settings-channel", with: [message]) {
            print("🧑‍🎤 history channel \(self.manager.socketURL)")
            print("🧑‍🎤 batteryState sent")
        //    Alerts.displayAlert(with: "🧑‍🎤 batteryState sent", and: state)
        }
    }
    
    func uploadBatteryPorcentage(porcentage: String) {
        let params = ["type": "batteryPorcentage", "batteryPorcentage": porcentage, "deviceId": SettingsBundleHelper.shared.deviceID ?? "no device id", "userId": SessionManager.shared.user?.userId ?? ""]
        let message = ["message": params]

        print("🧑‍🎤 \(message)")
        self.socket.emit("Settings-channel", with: [message]) {
            print("🧑‍🎤 history channel \(self.manager.socketURL)")
            print("🧑‍🎤 batteryPorcentage sent")
          // Alerts.displayAlert(with: "battery percentage", and: porcentage)
        }
    }
    
    func uploadTotalDistanceInTrace(distance: Double) {
        let params = ["type": "jobDistance", "distance": distance, "deviceId": SettingsBundleHelper.shared.deviceID ?? "no device id", "userId": SessionManager.shared.user?.userId ?? "no user id", "jobId": JobManager.jobId ?? "no job id"] as [String : Any]
        let message = ["message": params]

        print("🧑‍🎤 \(params)")
        self.socket.emit("Settings-channel", with: [message]) {
            print("🧑‍🎤 jobDistance sent")
          //  Alerts.displayAlert(with: "battery percentage", and: "sent")
        }
    }
    
    func uploadSilentMode(isPhoneInSilentMode: Bool) {
        let params = ["type": "silentMode", "isPhoneInSilentMode": isPhoneInSilentMode, "deviceId": SettingsBundleHelper.shared.deviceID ?? "no device id", "userId": SessionManager.shared.user?.userId ?? "no user id"] as [String : Any]
        let message = ["message": params]

        print("🧑‍🎤 \(params)")

        self.socket.emit("Settings-channel", with: [message]) {
            print("🧑‍🎤 silentMode sent")
          //  Alerts.displayAlert(with: "battery percentage", and: "sent")
        }
    }
    
    func uploadNitificationStatus() {
        let params = ["type": "notificationsStatus", "notificationsStatus": SessionManager.shared.notificationsStatus, "deviceId": SettingsBundleHelper.shared.deviceID ?? "no device id", "userId": SessionManager.shared.user?.userId ?? "no user id"] as [String : Any]
        let message = ["message": params]

        print("🧑‍🎤 \(params)")

        self.socket.emit("Settings-channel", with: [message]) {
            print("🧑‍🎤 notificationsStatus sent")
        }
    }
    
    func succesBanner() {
        let succesFloatingBanner = FloatingNotificationBanner(title: "Socket IO",
        subtitle: "You are connected",
        style: .success)
        succesFloatingBanner.autoDismiss = true
        
        succesFloatingBanner.onTap = {
            succesFloatingBanner.dismiss()
        }
        
        succesFloatingBanner.onSwipeUp = {
            succesFloatingBanner.dismiss()
        }
        
        succesFloatingBanner.show()
    }
    
    func dangerBanner() {
        let succesFloatingBanner = FloatingNotificationBanner(title: "Socket IO",
        subtitle: "You are disconnected",
        style: .danger)
        succesFloatingBanner.autoDismiss = true
        
        succesFloatingBanner.onTap = {
            succesFloatingBanner.dismiss()
        }
        
        succesFloatingBanner.onSwipeUp = {
            succesFloatingBanner.dismiss()
        }
        
        succesFloatingBanner.show()
    }
}



