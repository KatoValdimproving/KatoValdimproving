//
//  SettingsBundleHelper.swift
//  NovaTrack
//
//  Created by developer on 5/20/19.
//  Copyright © 2019 Paul Zieske. All rights reserved.
//

import UIKit
import Foundation

struct SettingsBundleKeys {
    static let production = "productionSwitch"
    static let SSIDNames = "ssidNames"
    static let socketIO = "socketIOSwitch"
    static let statusBar = "StatusBar"
    static let contactAlerts = "contactAlerts"
    static let initialstateOfisProductionEnabled = "initialstateOfisProductionEnabled"
    static let build = "build"
    static let version = "version"
    static let initialStateOfSelectedHospital = "initialStateOfSelectedHospital"

}

enum RemoteSettingsKeys: String {
    case production
    case socketIO
    case ssids
}

enum Hospital: String {
    case henryford
    case lahey
    case other
}

class SettingsBundleHelper: NSObject {
    
    static let shared = SettingsBundleHelper()
    private override init() {
        super.init()
        self.initialDeviceID = self.deviceID
        
    }
    
    func addObserverEnvoriment() {
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsBundleHelper.shared.defaultsChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    func changeEnviromentAndTerminateSession(newEnvironment: Environment) {
        
        NaavSystemEnvironment.changeEnvironment(newEnvironment: newEnvironment)
        //AppEnvoriment.shared.enviroment = newEnvironment
        SocketIOManager.sharedInstance.switchEnvoriment()
        ChatManager.shared.switchEnvoriment()
        
    }
    
    @objc func defaultsChange() {
        //        print("SettingsBundleHelper defaultsChange")
         //       print("⚠️\(self.deviceID)")
        print(self.isProductionEnabled)
        //        print(self.SSIDNames)
//        print("-----------------")
//        print("⚠️base url: \(AppEnvoriment.shared.apiBaseUrl)")
//        print("⚠️code \(self.hospitalCode)")
//        print("⚠️hospital \(self.selectedHospital)")

        self.isProductionEnabled ? changeEnviromentAndTerminateSession(newEnvironment: .prod) : changeEnviromentAndTerminateSession(newEnvironment: .dev)
        //self.checkChangeInEnvoriment()
        
        
        
//       self.checkChangeOfHospital()
//
//        if self.deviceID != self.initialDeviceID {
//            self.initialDeviceID = self.deviceID
//            if SessionManager.shared.isLogedIn {
//              self.logOutFromSettings()
//            }
//        }
        
        //Set contact alerts displayin preference
      //  BeaconTracingManager.shared.shouldDisplayContactAlerts = self.shouldDisplayContactAlerts
    }
    
    func checkChangeInEnvoriment() {
        if initialstateOfisProductionEnabled != isProductionEnabled {
            print("🏆 did change envoriment")
            
            SocketIOManager.sharedInstance.switchEnvoriment()
            ChatManager.shared.switchEnvoriment()
            initialstateOfisProductionEnabled = isProductionEnabled
            
            if SessionManager.shared.isLogedIn {
                SessionManager.shared.terminateSessionLogOut()
            }
        }
    }
    
    func checkChangeOfHospital() {
//        if initialstateOfSelectedHospital != selectedHospital {
//            initialstateOfSelectedHospital = selectedHospital
//            if SessionManager.shared.isLogedIn {
//                SessionManager.shared.terminateSessionLogOut()
//            }
//        }
        
          if SessionManager.shared.isLogedIn &&  selectedHospital == .other {
            
            self.logOutFromSettings()
            
          }
//       else if !SessionManager.shared.isLogedIn && selectedHospital != .other {
//     //   SessionManager.shared.terminateSessionLogOut()
//        print("🍀🥣 !SessionManager.shared.isLogedIn && selectedHospital != .other")
////            SocketIOManager.sharedInstance.switchEnvoriment()
////            ChatManager.shared.switchEnvoriment()
//        SessionManager.shared.terminateSessionLogOut()
//
//        }
        
      //  if
        
    }

//    var selectedHospital: Hospital {
//        get {
//            if let hospital = UserDefaults.standard.string(forKey: "hospitals") {
//                return Hospital(rawValue: hospital)!
//            }
//            return Hospital.henryford
//        }
//
//        set {
//            let hospital = newValue.rawValue
//            UserDefaults.standard.set(hospital, forKey: "hospitals")
//        }
//    }
    
    func logOutFromSettings() {
            APIManager.sharedInstance.logOut(completionHandler: { [weak self] islogout,error in
                
                guard self != nil else {return}
                SessionManager.shared.logOutTime =  "\(Date().stringFromDateZuluFormat()) succes: \(islogout) TapedButton Web Service"
                
                if (error == nil) && islogout {
                    print("logout")
                    DispatchQueue.main.async() {
                      //  self?.dismissCustomAlert()
                        Constants.loading = false
                        SessionManager.shared.terminateSessionLogOut()
                    }
                    
                } else {
                 //   self?.dismissCustomAlert()
                    //   guard self!.currentReachabilityStatus != .notReachable else {  return }
                    // Alerts.alert(with: self,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                    print("error in logout")
                 //    Alerts.alert(with: self,for: Constants.SERVER_NOT_ANSWER, with: Constants.ERROR_TITLE)
                    
                    //                Alerts.alert(with: nil,for: (response.result.error?.localizedDescription)!, with: Constants.GENERAL_ERROR_TITLE)
                    
                }
            })
    }
    
    var initialstateOfSelectedHospital: Hospital {
        get {
            if let hospital = UserDefaults.standard.string(forKey: SettingsBundleKeys.initialStateOfSelectedHospital) {
                return Hospital(rawValue: hospital)!
            }
            return .henryford
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: SettingsBundleKeys.initialStateOfSelectedHospital)
        }
    }
    
    
    
    var testerId: String {
           get {
               if let testerId = UserDefaults.standard.string(forKey: "testerId") {
                return testerId
               } else {
                 return ""
               }
           }
           
           set {
               let testerId = newValue
               UserDefaults.standard.set(testerId, forKey: "testerId")
           }
       }
    
    var hospitalCode: String {
           get {
               if let hospital = UserDefaults.standard.string(forKey: "hospitalCode") {
                let trimmed = hospital.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmed
               } else {
                 return ""
               }
           }
           
           set {
               let hospital = newValue
               UserDefaults.standard.set(hospital, forKey: "hospitalCode")
           }
       }
    
    var selectedHospital: Hospital {
             get {
                if let hospital = Hospital(rawValue: hospitalCode) {
                 return hospital
                } else {
                return .other
                }
    
             }
             
//             set {
//                 let hospital = newValue.rawValue
//                 UserDefaults.standard.set(hospital, forKey: "hospitals")
//             }
         }
    
    
    var initialstateOfisProductionEnabled: Bool {
        get {
            let production = UserDefaults.standard.bool(forKey: SettingsBundleKeys.initialstateOfisProductionEnabled)
            return production
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsBundleKeys.initialstateOfisProductionEnabled)
        }
    }
    
    var isProductionEnabled: Bool {
        get {
            let production = UserDefaults.standard.bool(forKey: SettingsBundleKeys.production)
            return production
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsBundleKeys.production)
        }
    }
    
//    var SSIDNames: [String] {
//        get {
//            
//            guard let SSIDNamesString = UserDefaults.standard.string(forKey: SettingsBundleKeys.SSIDNames) else { return [] }
//            
//            if SSIDNamesString != "" {
//                let SSIDs = SSIDNamesString.components(separatedBy: ",")
//                var SSIDNamesCollection = [String]()
//                for SSID in SSIDs {
//                    SSIDNamesCollection.append(SSID.trim())
//                }
//                return SSIDNamesCollection
//                
//            }
//            else {
//                if SessionManager.shared.allowNotifications && SessionManager.shared.isAppInBackground {
//                   // NetworkManager.shared.sendLocalNotification(title: "Atention", subtitle: "SSID Names", body: "You have to add the names of the valid networks")
//                }
//            }
//            
//            return []
//        }
//    }
    
//    private  var SSIDNamesSetOnly: String {
//        get {
//            guard let SSIDNamesString = UserDefaults.standard.string(forKey: SettingsBundleKeys.SSIDNames) else { return "" }
//            return SSIDNamesString
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: SettingsBundleKeys.SSIDNames)
//        }
//    }
    
    var isSocketIOEnabled : Bool {
        get {
            let socketIOSwitchState = UserDefaults.standard.bool(forKey: SettingsBundleKeys.socketIO)
            return socketIOSwitchState
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsBundleKeys.socketIO)
        }
    }
    
    var deviceID : String?  {
        get {
            return  UserDefaults.standard.string(forKey: Constants.PHONE_IDENTIFIER)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.PHONE_IDENTIFIER)
        }
    }
    
    var initialDeviceID : String?  {
        get {
            return  UserDefaults.standard.string(forKey: "initialDeviceID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "initialDeviceID")
        }
    }
    
    
    
    var isStatusBarEnabled : Bool {
        get {
            let statusBarSwitchState = UserDefaults.standard.bool(forKey: SettingsBundleKeys.statusBar)
            return statusBarSwitchState
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsBundleKeys.statusBar)
        }
    }
    
    var isFirstLunchEver: Bool {
        get {
            let isFirstLunchEverExist = UserDefaults.standard.value(forKey: "isFirstLunchEver")
            isFirstLunchEverExist == nil ? UserDefaults.standard.set(true, forKey: "isFirstLunchEver") : UserDefaults.standard.set(false, forKey: "isFirstLunchEver")
            return UserDefaults.standard.bool(forKey: "isFirstLunchEver")
        }
    }
    
    var shouldDisplayContactAlerts: Bool {
        get {
            return UserDefaults.standard.bool(forKey: SettingsBundleKeys.contactAlerts)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsBundleKeys.contactAlerts)
        }
    }
    
    func setInitialInfo() {
        self.isProductionEnabled = false
        self.initialstateOfisProductionEnabled = false
        self.deviceID = "402026"
        self.isStatusBarEnabled = false
      //  self.SSIDNamesSetOnly = ""
        self.hospitalCode = "henryford"
      //  AppEnvoriment.shared.setProductionEnvoriment()
      //  self.selectedHospital = .other
      
    }
}


