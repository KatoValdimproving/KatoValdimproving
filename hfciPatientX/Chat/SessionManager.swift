//
//  SessionManager.swift
//  NovaTrack
//
//  Created by developer on 5/9/19.
//  Copyright © 2019 Paul Zieske. All rights reserved.
//

import UIKit

struct SessionManagerKeys {
    static let isLogedIn = "isLogedIn"
    static let user = "user"
    static let allowNotifications = "allowNotifications"
    static let sessionId = "sessionId"
    static let isSessionActive = "isSessionActive"
    static let expireSessionDate = "expireSessionDate"
    static let campus = "campus"
    static let loginTime = "loginTime"
    static let logOutTime = "logOutTime"
    static let firebaseToken = "firebaseToken"
    static let didAutologin = "didAutologin"
    static let shortPayload = "shortPayload"

}

enum MessagesTypes: String {
    case jobId = "job"
    case logout = "logout"
    case broadcast = "broadcast"
    case login = "login"
    case logs = "logs"
    case history = "history"
    case geolocation = "geolocation"


}

class SessionManager: NSObject {
    
    static let shared = SessionManager()
    private override init() {}
    
    var isLogedIn : Bool {
        get {
            return  UserDefaults.standard.bool(forKey: SessionManagerKeys.isLogedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SessionManagerKeys.isLogedIn)
        }
    }
    
    var notificationsStatus = ""
    
    var logInDate = ""
    
    var user : User? {
        get {
//            guard let data = UserDefaults.standard.value(forKey: SessionManagerKeys.user) as? Data else { return nil }
//            let userStored = try? PropertyListDecoder().decode(User.self, from: data)
//            return userStored
            
           // let decoder = JSONDecoder()

            guard let savedPerson = UserDefaults.standard.object(forKey: SessionManagerKeys.user) as? Data else { return nil }
                let decoder = JSONDecoder()
            do {
             let loadedPerson = try decoder.decode(User.self, from: savedPerson)
                return loadedPerson

             } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
                   // print(loadedPerson.name)
                return nil
            
        }
        set {
            
            do {
                guard let value = newValue else {
                    return
                }
                let encoder = JSONEncoder()
                let encoded = try encoder.encode(value)

                UserDefaults.standard.set(encoded, forKey: SessionManagerKeys.user)


            } catch {
                 print(error.localizedDescription)
            }
       //     UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: SessionManagerKeys.user)
        }
    }
    
    
     var campus : Campus? {
            get {
    //            guard let data = UserDefaults.standard.value(forKey: SessionManagerKeys.user) as? Data else { return nil }
    //            let userStored = try? PropertyListDecoder().decode(User.self, from: data)
    //            return userStored
                
               // let decoder = JSONDecoder()

                guard let savedPerson = UserDefaults.standard.object(forKey: SessionManagerKeys.campus) as? Data else { return nil }
                    let decoder = JSONDecoder()
                do {
                 let loadedPerson = try decoder.decode(Campus.self, from: savedPerson)
                    return loadedPerson

                 } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
                       // print(loadedPerson.name)
                    return nil
                
            }
            set {
                
                do {
                    guard let value = newValue else {
                        return
                    }
                    let encoder = JSONEncoder()
                    let encoded = try encoder.encode(value)

                    UserDefaults.standard.set(encoded, forKey: SessionManagerKeys.campus)


                } catch {
                     print(error.localizedDescription)
                }
           //     UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: SessionManagerKeys.user)
            }
        }
    
    
    var allowNotifications : Bool {
        get {
            return  UserDefaults.standard.bool(forKey: SessionManagerKeys.allowNotifications)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SessionManagerKeys.allowNotifications)
        }
    }
    
    var didAutologIn : Bool {
        get {
            return  UserDefaults.standard.bool(forKey: SessionManagerKeys.didAutologin)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SessionManagerKeys.didAutologin)
        }
    }
    
    var isAppInBackground = false
    
    var sessionId : String? {
        get {
            return  UserDefaults.standard.string(forKey: SessionManagerKeys.sessionId)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SessionManagerKeys.sessionId)
        }
    }
    
    var isSessionActive: Bool {
        get {
            guard self.sessionId != nil else { return false }
            return true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SessionManagerKeys.isSessionActive)
        }
    }
    
    
   var expireSessionDate: Date? {
        get {
            let stringDate = UserDefaults.standard.string(forKey: SessionManagerKeys.expireSessionDate)
            return stringDate?.dateFromString()
        }
        set {
            let stringDate = newValue?.stringFromDate()
            UserDefaults.standard.set(stringDate, forKey: SessionManagerKeys.expireSessionDate)
        }
    }
    
    func startTimerToExpireSession() {
        guard let date = self.expireSessionDate else { return }
        SessionManager.shared.logOutTime =  "\(Date().stringFromDateZuluFormat()) Log Out after 12 hours"
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(terminateSessionLogOut), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    
    var loginTime : String? {
           get {
               return  UserDefaults.standard.string(forKey: SessionManagerKeys.loginTime)
           }
           set {
               UserDefaults.standard.set(newValue, forKey: SessionManagerKeys.loginTime)
           }
       }
    
    var userName : String? {
           get {
               return  UserDefaults.standard.string(forKey: "userName")
           }
           set {
               UserDefaults.standard.set(newValue, forKey: "userName")
           }
       }
    
    var logOutTime : String? {
        get {
            return  UserDefaults.standard.string(forKey: SessionManagerKeys.logOutTime)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SessionManagerKeys.logOutTime)
        }
    }
    
    var firebaseToken : String? {
        get {
            return  UserDefaults.standard.string(forKey: SessionManagerKeys.firebaseToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SessionManagerKeys.firebaseToken)
        }
    }
    
    
    
//    func terminateSession(withTokentime seconds: Int) {
//        let date = Date().addingTimeInterval(TimeInterval(seconds))
//        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(terminateSessionLogOut), userInfo: nil, repeats: false)
//        RunLoop.main.add(timer, forMode: .commonModes)
//    }
    
    func loginService(user: String, password: String) {
        APIManager.sharedInstance.login(viewController: nil, password: password, email: user,  completionHandler: { [weak self] loginResponseObject, jobId, error in
            if Constants.loading {
              //  self?.dismissCustomAlert()
                Constants.loading = false
            }
         //   guard self != nil else { self?.dismissCustomAlert(); return }
            
            if loginResponseObject == nil && self != nil {
              //  self!.loginError()
                print("error login \(String(describing: error?.localizedDescription))")
            } else {
                self?.processLogin(user: loginResponseObject!, email: user, jobId: jobId)
            }
        })
    }
    
    func processLogin(user: User, email:String, jobId: String?) {
        
        SocketIOManager.sharedInstance.establishConnection()
        JobManager.jobId = jobId
        print("🍀 🎗 JobManager.jobId \(String(describing: JobManager.jobId))")
      //  LocationManager.sharedInstance.startLocationUpdates()
        SessionManager.shared.isLogedIn = true
         SessionManager.shared.sessionId = user.id
//        CoreDataManager.sharedInstance.currentSession = Session.instance(context: CoreDataManager.sharedInstance.viewContext, id: user.id)
//         CoreDataManager.sharedInstance.currentJob = Job.createAndSaveJob(context: CoreDataManager.sharedInstance.viewContext, id: JobManager.jobId ?? "n/a")
//         CoreDataManager.sharedInstance.save()
        
        SessionManager.shared.loginTime = Date().stringFromDateZuluFormat()
      //  IQKeyboardManager.shared.enableAutoToolbar = false
        SessionManager.shared.user = user
     //   SessionManager.shared.expireSessionDate = Date().addingTimeInterval(TimeInterval(user.title))
     //   SessionManager.shared.startTimerToExpireSession()
     //   SocketIOManager.sharedInstance.uploadLocationAccessDenied(status: PayloadCreator.shared.getCurrentLocationPermissionStatus())

        //Initiate beacons detection
     //   ContactTracing.shared.userId = user.userId
        
//        if let campusName = SessionManager.shared.campus?.campusIMDF.getIMDFFolderName() {
//            let levelUrl = Bundle.main.resourceURL!.appendingPathComponent("\(campusName)/level.geojson")
//            let unitUrl = Bundle.main.resourceURL!.appendingPathComponent("\(campusName)/unit.geojson")
//
//            if let levelData = try? Data(contentsOf: levelUrl),
//                let unitData = try? Data(contentsOf: unitUrl) {
//                ContactTracing.shared.initiateUnitDetection(levelData: levelData, unitData: unitData, completion: {
//                    BeaconTracingManager.shared.getBeacons(shouldMonitor: true)
//                })
//            }
//        }
//        else {
//            BeaconTracingManager.shared.getBeacons(shouldMonitor: true)
//        }
        
//        if  let _ = SessionManager.shared.campus?.campusIMDF.getIMDFFolderName()  {
//            do {
//                let imdfDecoder = IMDFDecoder()
//                guard let levelData =  try?  Data(contentsOf: imdfDecoder.getURLFor(file: .level) ?? URL(fileURLWithPath: "")) else { return }
//                guard let unitData =   try? Data(contentsOf: imdfDecoder.getURLFor(file: .unit) ?? URL(fileURLWithPath: "")) else { return }
//                ContactTracing.shared.initiateUnitDetection(levelData: levelData, unitData: unitData, completion: {
//                    BeaconTracingManager.shared.getBeacons(shouldMonitor: true)
//                })
//            }
//        } else {
//            BeaconTracingManager.shared.getBeacons(shouldMonitor: true)
//        }
        
//        self.userDefaults.set(user.userId, forKey: Constants.NAME_DRAWER_KEY)
//        if let password = self.passwordTxtField.text {
//            _ = KeychainWrapper.standard.set(password, forKey: "password")
//        }
//        self.userDefaults.set(email, forKey: Constants.USE_NAME_KEY)
//
        UserDefaults.standard.setUserID(value: user.userId)
        print("TokenId", user.id)
        UserDefaults.standard.setTokenId(value: user.id)
        Constants.logged_in = true
            
      //  CoreDataManager.sharedInstance.removeLogsOlderThan(days: 3)
         
        guard let campusId = SessionManager.shared.user?.campusId else { return }
   
//        APIManager.sharedInstance.getCampus(campusId: campusId) { (campus) in
//            guard let campus = campus else { return }
//            SessionManager.shared.campus = campus
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  { return }
//            guard let campusName = SessionManager.shared.campus?.campusIMDF.getIMDFFolderName() else { return }
//            appDelegate.setUpIMDF(name: campusName)
////            TraceHealingManager.shared.start()
////            FlowCoordinator.showInitialScreenTabViewController()
//        }
    }
    
    @objc func terminateSessionLogOut() {
        SessionManager.shared.didAutologIn = false
        SessionManager.shared.isLogedIn = false
      //  LocationManager.sharedInstance.stopLocationUpdates()
        Constants.loggedBattery = false
        Constants.loggedSSID = false
      //  UIApplication.shared.statusBarStyle = .lightContent
        Constants.logged_in = false
        ChatManager.shared.disconnect()
        UserDefaults.standard.setRecentChats(value: nil)
//        FlowCoordinator.showLogInScreenAfterLogOut()
//        BeaconTracingManager.shared.handleLogout()
        
//        SocketIOManager.sharedInstance.uploadTotalDistanceInTrace(distance: LocationStreaming.sharedInstance.distance ?? -1.0)
//
//        if let currentSession = CoreDataManager.sharedInstance.fetchCurrentSession() {
//            currentSession.end = Date()
//        }
        
        guard let jobId = JobManager.jobId else { return }
       
//        CoreDataManager.sharedInstance.updateLastJobTotalLogsValueForEveryLog(jobId: jobId) { (succes) in
//            print("update de todos \(succes)")
//        }
//        CoreDataManager.sharedInstance.updateLastJobLogOutTimeValueForEveryLog(jobId: jobId) { (succes) in
//                   print("update de logouttime \(succes)")
//         }
        
       // CoreDataManager.sharedInstance.fetchAllAppStates()
        
//
        JobManager.jobId = nil
         SocketIOManager.sharedInstance.closeConnection()
        ChatManager.shared.closeConnection()
        
      //  SocketIOManager.sharedInstance.uploadTotalAmountOfLogsInJob()
    }
    
    func checkIncomingMessageToTerminateSession(data: [Any]) {
        guard let responce: [String: Any] = data.first as? [String : Any] else { return }
        
        guard let type = responce.valueForKeyPath(keyPath: "type") as? String else { return }

        if type == MessagesTypes.logout.rawValue {
            
            if let dictionary = responce.valueForKeyPath(keyPath: "message") as? [String : Any] {
                if let isUserLogged: Bool = dictionary.valueForKeyPath(keyPath: "isUserLogged") as? Bool, let userId = dictionary.valueForKeyPath(keyPath: "user_id") as? String {
                 //   print(responce)
                    if isUserLogged == false && userId == SessionManager.shared.user?.userId {
                       // print("Terminate session")
                        SessionManager.shared.logOutTime =  "\(Date().stringFromDateZuluFormat()) Terminate session Socket IO"
                        terminateSessionLogOut()
                        
                        SocketIOManager.sharedInstance.socket.emit("HFHTransport-1", with: [["userId": SessionManager.shared.user?.userId ?? "", "deviceId": SettingsBundleHelper.shared.deviceID ?? "", "socketId": SocketIOManager.sharedInstance.socket.sid]]) {
                            print("Sent confirmation")
                        }
                    }
                }
            }
        }
    }
    
    func checkIncomingMessageToGetJobId(data: [Any]) {
        guard let responce: [String: Any] = data.first as? [String : Any] else { return }
     //   print(responce)
        guard let type = responce.valueForKeyPath(keyPath: "type") as? String else { return }

        if type == MessagesTypes.jobId.rawValue {

            if let dictionary = responce.valueForKeyPath(keyPath: "message") as? [String : Any] {
                if let userId = dictionary.valueForKeyPath(keyPath: "user_id") as? String {
                    if userId == SessionManager.shared.user?.userId {
                        if let jobId = dictionary.valueForKeyPath(keyPath: "id") as? String {
                            JobManager.jobId = jobId

                          //  _ = Session.instance(context: CoreDataManager.sharedInstance.viewContext, id: userObject.id)
                          //  Job.instance(context: CoreDataManager.sharedInstance.viewContext, id: "")
//                            CoreDataManager.sharedInstance.currentJob = Job.createAndSaveJob(context: CoreDataManager.sharedInstance.viewContext, id: jobId)
//                            CoreDataManager.sharedInstance.save()

//                            SessionManager.shared.isLogedIn = true
//                            TraceHealingManager.shared.start()
//                            FlowCoordinator.showInitialScreen()
                         //   Session.instance(context: CoreDataManager.sharedInstance.viewContext, id:  SessionManager.shared.sessionId ?? "n/a")
                           // CoreDataManager.sharedInstance.save()
                        }
                    }
                }

            }
        }
    }
    
    
//    func checkIncomingMessageToHnaldeDuplicatedPhoneId(data: [Any]) {
//          guard let responce: [String: Any] = data.first as? [String : Any] else { return }
//          print(responce)
//          guard let type = responce.valueForKeyPath(keyPath: "type") as? String else { return }
//
//          if type == MessagesTypes.login.rawValue {
//
//              if let dictionary = responce.valueForKeyPath(keyPath: "message") as? [String : Any] {
//
//
//
//                if let userId = dictionary.valueForKeyPath(keyPath: "user_id") as? String {
//                      if userId == SessionManager.shared.user?.userId {
////                          if let jobId = dictionary.valueForKeyPath(keyPath: "id") as? String {
////                              JobManager.jobId = jobId
////                            // print(JobManager.jobId)
////                          }
//                        Alerts.displayAlert(with: "Duplicate phone id", and: "Please contact you")
//                      }
//                  }
//
//              }
//          }
//      }
    
    func autoLogout() {
          if NetworkManager.shared.isNetworkAvailable == false {
              SessionManager.shared.logOutTime =  "\(Date().stringFromDateZuluFormat()) LogOut Locally"
              SessionManager.shared.terminateSessionLogOut()
          }
          
         if SettingsBundleHelper.shared.isProductionEnabled {
                   if APIManager.validateNetworkSettings() == false { return }
               }

          if !Constants.loading {
            //  self.presentLoader()
              Constants.loading = true
          }
          APIManager.sharedInstance.logOut(completionHandler: { [weak self] islogout,error in
              
              guard self != nil else {return}
              SessionManager.shared.logOutTime =  "\(Date().stringFromDateZuluFormat()) succes: \(islogout) autologout"

              if (error == nil) && islogout {
                  print("logout")
                  DispatchQueue.main.async() {
                   //   self?.dismissCustomAlert()
                      Constants.loading = false
                   SessionManager.shared.terminateSessionLogOut()
                  }
                  
              } else {
//                  self?.dismissCustomAlert()
//                  guard self!.currentReachabilityStatus != .notReachable else {  return }
//                  Alerts.alert(with: self,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                  print("error in logout")
              }
          })
          
      }

}
