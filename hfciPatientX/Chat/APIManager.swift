//
//  APIManager.swift
//  NovaTrack
//
//  Created by Developer on 1/18/18.
//  Copyright © 2018 Paul Zieske. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import Gloss
import NotificationBannerSwift
import CoreLocation

class APIManager: NSObject {
    
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    let ACCOUNTS = "accounts/"
    let GET_ACCOUNTS = "accounts/?access_token="
    let GET_USER = "accounts/"
    let GET_EQUIPMENT = "equipment"
    let GET_BADGES = "badges"
    let POST_EQUIPMENT_LOG = "equipment_crowdsources"
    let POST_BADGE_LOG = "contact_events"
    let ACCEPT_TYPE = "application/json"
    let RESET = "reset"
    //let AUTH_TOKEN = "Authtoken"
    let ACCEPT = "Accept"
    let LOGIN = "login"
    let LOCATIONS = "jobs?access_token="
    let EMAIL = "email"
    let PASSWORD = "password"
    let LOGOUT = "logout?access_token="
    let ACCESS_TOKEN = "&access_token="
    let DEVICEID = "device_id"
    let DELAYCODE = "delay_codes?access_token="
    let STATS_IMAGES_ENDPOINT = "status_code?access_token="
    let PATIENTS_ENDPOINT = "mrn_patients?access_token="
    let MESSAGE_DAYMESSAGE = "messages/dayMessages?channel="
    let EXPIRED_CODE = 401
    let OK_CODE = 200
    
    enum SessionStatus {
        
    }
    
   // var envoriment = SocketIOEndPoint()
    
    static func validateNetworkSettings() -> Bool {
        
        if NetworkManager.shared.isNetworkAvailable {
            if  NetworkManager.shared.conectionBy == .wifi {
//                if let currentSSID = NetworkManager.shared.currentSSID  {
//                    if SettingsBundleHelper.shared.SSIDNames.contains(currentSSID) {
//                        return true
//                    } else {
//                        Alerts.displayAlert(with: "Somethign went wrong", and: "Check your SSID names in your Settings")
//                        return false
//                    }
//                } else {
//                    Alerts.displayAlert(with: "Somethign went wrong", and: "Check your internet connection")
//                    return false
//                }
//            } else {
//                Alerts.displayAlert(with: "Somethign went wrong", and: "You are not connected to wifi")
//                return false
//            }
                return true
        } else {
          //  Alerts.displayAlert(with: "Somethign went wrong", and: "You have no internet connection")
            return false
        }
        }
        
        return false
        
        
    }
    
//    static func validateIfNetworkIsAvailableAndConnectedToWifiAndSSIDsIsInTheDesignatedNetworks() -> Bool {
//        guard let currentSSID = NetworkManager.shared.currentSSID else { return false }
//        if NetworkManager.shared.isNetworkAvailable && NetworkManager.shared.conectionBy == .wifi && SettingsBundleHelper.shared.SSIDNames.contains(currentSSID){
//            return true
//        } else {
//            return false
//        }
//    }
    
    func getUsers (completionHandler: @escaping ( [[String : AnyObject]], NSError?) -> ()) {
        
        guard let tokenId = UserDefaults.standard.getTokenId() else { return }
        
        print(AppEnvoriment.shared.apiBaseUrl + GET_ACCOUNTS +  tokenId)
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + GET_ACCOUNTS + tokenId)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            if response.result.isSuccess {
                if response.response?.statusCode == self.OK_CODE {
                    guard let userObject : [[String : AnyObject]] = response.result.value as? [[String : AnyObject]]  else {
                        return
                    }
                    completionHandler(userObject,nil)
                } else if response.response?.statusCode == self.EXPIRED_CODE {
                    //verify session closed and take off the app
                  //  Alerts.alertSessionExpired()
                } else {
                    // Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                }
            } else {
                
                //Alerts.alert(with: nil,for: (response.result.error?.localizedDescription)!, with: Constants.GENERAL_ERROR_TITLE)
            }
        }
        
        
        
    }
    
    //POST Login Request
    func login (viewController : UIViewController?, password : String, email:String , completionHandler: @escaping (_ user: User?, _ jobId: String?, _ error: NSError?) -> ()) {
        
        
        if let udid = UserDefaults.standard.string(forKey: Constants.PHONE_IDENTIFIER) {
            let param =  [EMAIL: email, PASSWORD : password , DEVICEID : udid, Constants.TTL_KEY : Constants.TTL_VALUE, "tokenFirebase": SessionManager.shared.firebaseToken ?? ""] as [String : Any]
            print(param)
            
            
            let url = URL(string: AppEnvoriment.shared.apiBaseUrl + ACCOUNTS + LOGIN + "?include=USER")!
            print("😍 \(url)")
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 5 // or what you want
            
            Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
                
                
                
                switch response.result {
            
                    
                case .success(let value):
                    print("😍 login-> \(response)")
                    
                    guard let dictionary = value as? [String: Any] else {
                        completionHandler(nil, nil, nil)
                        return
                    }
                    
                    if dictionary.keys.contains("error") {
                        if let errorInfo = dictionary["error"] as? [String : Any] {
                            if(errorInfo.keys.contains("statusCode")){
                                if(errorInfo["statusCode"] as! Int == 500){
                                    Alerts.displayAlert(with: "Error", and: Constants.SERVER_NOT_ANSWER)
                                } else {
                                    Alerts.displayAlert(with: "Error", and: errorInfo["message"] as! String)
                                }
                            } else {
                                Alerts.displayAlert(with: "Error", and: "Could not connect to the server.")
                            }
                        }else{
                            Alerts.displayAlert(with: "Error", and: "Could not connect to the server.")
                        }
                        completionHandler(nil, nil, nil)
                        return
                    }
    
                    guard let data = response.data else { return }
                    
                    do {
                        let jobManager = try JSONDecoder().decode(JobManager.self, from: data)
                        let userObject = try JSONDecoder().decode(User.self, from: data)
                        completionHandler(userObject, jobManager.jobId, nil)
                        
                    } catch let error {
                        print(error.localizedDescription)
                        completionHandler(nil, nil, error as NSError)
                    }
                case .failure(let error):
                    print("😍 \(error.localizedDescription)")
                    if error._code == NSURLErrorTimedOut {
                        // timeout error statement
                        completionHandler(nil, nil, error as NSError)
                        Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                        //viewController?.presentAlert(withTitle: Constants.ERROR_TITLE, message: (response.result.error?.localizedDescription)!)
                    } else {
                        // other error statement
                        Alerts.displayAlert(with: "Error", and: "Could not connect to the server.")
                        completionHandler(nil, nil, error as NSError)
                    }
                }
            }
            
        } else {
            Alerts.alert(with: nil, for: "Add phone identifier first", with: "Missing info")
        }
    }
    
    func resetPass (email:String, completionHandler: @escaping (Bool?, NSError?) -> ()) {
        
        
        let udid = UIDevice.current.identifierForVendor!.uuidString
        let param =  [EMAIL: email, Constants.TTL_KEY : Constants.TTL_VALUE] as [String : Any]
        
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + ACCOUNTS + RESET)!, method: .post, parameters: param, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            if response.result.isSuccess  {
                if response.response?.statusCode != 404 {//self.OK_CODE {
                    //if expected response send it
                    completionHandler(true,nil)
                } else {
                    //send nils to evaluate on handler
                    completionHandler(nil, nil)
                }
            } else {
                completionHandler(nil, nil)
                Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
            }
        }
        
    }
    
    //POST closeJob Request todo
    func closeJob (information : [String : Any] , completionHandler: @escaping (Bool?, NSError?) -> ()) {
        
        guard let tokenId = UserDefaults.standard.getTokenId() else { return }
        
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + LOCATIONS + tokenId)!, method: .post, parameters: information, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            
            if response.result.isSuccess  {
                if response.response?.statusCode == self.OK_CODE {
                    //if expected response send it
                    completionHandler(true,nil)
                } else {
                    //send nils to evaluate on handler
                    completionHandler(false, nil)
                }
            } else {
                completionHandler(false, nil)
                Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                
                //viewController?.presentAlert(withTitle: Constants.ERROR_TITLE, message: (response.result.error?.localizedDescription)!)
            }
        }
        
    }
    
    //LogOut ask to server to close your token
    func logOut (completionHandler: @escaping ( Bool, NSError?) -> ()) {
        
        guard let tokenId = UserDefaults.standard.getTokenId() else { return }
        
         let params = ["userId": SessionManager.shared.user?.userId ?? "", "totalLogsInJob": 0, "jobId": JobManager.jobId ?? "", "jobHasTraceHealing": -1] as [String : Any]
        print("paramsss \(params)")
        
         print("\(AppEnvoriment.shared.apiBaseUrl + ACCOUNTS + LOGOUT + tokenId)")
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + ACCOUNTS + LOGOUT + tokenId)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            print("logout-> \(response.result)")
//            switch response.result {
//
//            case .success(let value):
//                guard let dictionary = value as? [String: Any] else {
//                    completionHandler(false, nil)
//                    return
//                }
//
//                print(dictionary)
//
//                if dictionary.keys.contains("error") {
//                    Alerts.displayAlert(with: "Error", and: "Unable to log out please try again later")
//                    completionHandler(false, nil)
//                    return
//                }
//
//                 let code = dictionary["code"] as? Int ?? 0
//                if code == 200 {
//                    completionHandler(true,nil)
//                } else {
//                    completionHandler(false, nil)
//                }
//
//            case .failure(let error):
//                Alerts.displayAlert(with: "Error", and: "Unable to log out please try again later")
//                completionHandler(false, nil)
//

//            }
            
                        if response.result.isSuccess {
                            completionHandler(true,nil)
                        } else {
                            completionHandler(false, nil)
                        }
        }
        
    }
    
    ///Get Delay codes
    func getDelayCodes (completionHandler: @escaping ( [[String : AnyObject]], NSError?) -> ()) {
        
        guard let tokenId = UserDefaults.standard.getTokenId() else { return }
        
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + DELAYCODE +  tokenId)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            
            if response.result.isSuccess {
                if response.response?.statusCode == self.OK_CODE {
                    guard let userObject : [[String : AnyObject]] = response.result.value as? [[String : AnyObject]]  else {
                        return
                    }
                    completionHandler(userObject,nil)
                } else if response.response?.statusCode == self.EXPIRED_CODE {
                    //verify session closed and take off the app
                    Alerts.alertSessionExpired()
                } else {
                    Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                }
            } else {
                
                Alerts.alert(with: nil,for: (response.result.error?.localizedDescription)!, with: Constants.GENERAL_ERROR_TITLE)
            }
        }
        
    }
    
    //MARK: get Patients
    func getPatients (completionHandler: @escaping ( [[String : AnyObject]], NSError?) -> ()) {
        
        guard let tokenId = UserDefaults.standard.getTokenId() else { return }
        
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + PATIENTS_ENDPOINT +  tokenId)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            if response.result.isSuccess {
                if response.response?.statusCode == self.OK_CODE {
                    guard let patientsJSON : [[String : AnyObject]] = response.result.value as? [[String : AnyObject]]  else {
                        return
                    }
                    completionHandler(patientsJSON,nil)
                } else if response.response?.statusCode == self.EXPIRED_CODE {
                    //verify session closed and take off the app
                    Alerts.alertSessionExpired()
                } else {
                    Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                }
            } else {
                
                Alerts.alert(with: nil,for: (response.result.error?.localizedDescription)!, with: Constants.GENERAL_ERROR_TITLE)
            }
        }
        
    }
    
    func getStatusCode (completionHandler: @escaping ( [[String : AnyObject]], NSError?) -> ()) {
        
        guard let tokenId = UserDefaults.standard.getTokenId() else { return }
        
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + STATS_IMAGES_ENDPOINT +  tokenId)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            if response.result.isSuccess {
                if response.response?.statusCode == self.OK_CODE {
                    guard let statsImgs : [[String : AnyObject]] = response.result.value as? [[String : AnyObject]]  else {
                        return
                    }
                    completionHandler(statsImgs,nil)
                } else if response.response?.statusCode == self.EXPIRED_CODE {
                    //verify session closed and take off the app
                    Alerts.alertSessionExpired()
                } else {
                    Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                }
            } else {
                
                Alerts.alert(with: nil,for: (response.result.error?.localizedDescription)!, with: Constants.GENERAL_ERROR_TITLE)
            }
        }
        
    }
    
    //MARK: get route from endpoint sending start an end ids
    func getRoute(startId: String, endId: String, completionHandler: @escaping ( [[String: AnyObject]], NSError?) -> ()) {
        
        Alamofire.request(URL(string: String(format: WebLinkRoute.ROUTE_URL, arguments: [startId, endId]))!, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: [ACCEPT:ACCEPT_TYPE]).responseJSON {
            (response) in
            if response.result.isSuccess {
                //verify session closed and take off the app
                guard response.response?.statusCode != self.EXPIRED_CODE else { Alerts.alertSessionExpired(); return }
                guard let routeObj : [[String : AnyObject]] = (response.result.value as? [String : AnyObject])?.valueForKeyPath(keyPath: Constants.FEATURES_KEYPATH) as? [[String : AnyObject]]  else {
                    return
                }
                completionHandler(routeObj,nil)
            } else {
                Alerts.alert(with: nil,for: (response.result.error?.localizedDescription)!, with: Constants.GENERAL_ERROR_TITLE)
            }
        }
        
    }
    
    //MARK: getChatHistory from server and show all messages
//    func getChatHistoryForDay(OTOchannel:String, completionHandler: @escaping ( [[String : AnyObject]], NSError?) -> ()) {
//
//        guard let tokenId = UserDefaults.standard.getTokenId() else { return }
//
//        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + MESSAGE_DAYMESSAGE + OTOchannel + ACCESS_TOKEN +  tokenId)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
//            if response.result.isSuccess{
//                //verify session closed and take off the app
//                guard response.response?.statusCode != self.EXPIRED_CODE else { Alerts.alertSessionExpired(); return }
//                guard let historyObj : [[String : AnyObject]] = (response.result.value as? [String : AnyObject])?.valueForKeyPath(keyPath: Constants.MESSAGES_KEYPATH) as? [[String : AnyObject]]  else {
//                    return
//                }
//                completionHandler(historyObj,nil)
//            } else {
//                Alerts.alert(with: nil, for: (response.result.error?.localizedDescription)!, with: Constants.GENERAL_ERROR_TITLE)
//            }
//        }
//    }
//
//    func getUserLocation(userId:String, completionHandler: @escaping (_ user:FindMyUser?) -> Void) {
//        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + GET_USER + userId)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
//
//            if response.result.isSuccess,
//                let jsonData = response.data {
//
//                let jsonDecoder = JSONDecoder()
//                do {
//                    let user = try jsonDecoder.decode(FindMyUser.self, from: jsonData)
//                    completionHandler(user)
//                }
//                catch(let error) {
//                    print(error)
//                }
//                return
//            }
//            completionHandler(nil)
//        }
//    }
    
    func getCampus(campusId:String, completionHandler: @escaping (_ user:Campus?) -> Void) {
        //  let params = ["campus": campusId]
       // "https://itxlin09.itexico.com/socket.io"
       // "https://novatrack.hfhs.org/api/"
        //https://sandbox-hfhs.navvtrak.com/api/campuses/
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + "campuses/" + campusId)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            
            if response.result.isSuccess, let jsonData = response.data {
                print("campus -> \(response)")
                let jsonDecoder = JSONDecoder()
                do {
                    let campus = try jsonDecoder.decode(Campus.self, from: jsonData)
                    completionHandler(campus)
                }
                catch(let error) {
                    print(error)
                    completionHandler(nil)
                    
                }
                
            } else {
                print(response.error?.localizedDescription)
            }
            //completionHandler(nil)
        }
    }
    
    
    
    func autologin (userId : String, webToken:String, firebaseToken: String, deviceId: String, completionHandler: @escaping (_ user: User?, _ jobId: String?, _ error: NSError?) -> ()) {
        
        
      //  if let udid = UserDefaults.standard.string(forKey: Constants.PHONE_IDENTIFIER) {
            
        //    let param =  [EMAIL: email, PASSWORD : password , DEVICEID : udid, Constants.TTL_KEY : Constants.TTL_VALUE, "tokenFirebase": SessionManager.shared.firebaseToken ?? ""] as [String : Any]
        let param = ["userId":userId, "webtoken": webToken, "tokenFirebase": firebaseToken, "device_id": deviceId]
            print(param)
            
           // https://itxlin09.itexico.com/api/accounts/forceLogin
            
         //   let url = URL(string: "http://itxlin09.itexico.com:3050/api/accounts/forceLogin?userId=\(userId)&webtoken=\(webToken)&device_id=\(deviceId)&tokenFirebase=\(firebaseToken)")!
        let url = URL(string: "https://sandbox-hfhs.navvtrak.com/api/accounts/forceLogin")!
        print(url)
            var urlRequest = URLRequest(url: url)
            urlRequest.timeoutInterval = 5 // or what you want
            
        Alamofire.request(url, method: .post, parameters: param, encoding: URLEncoding.queryString, headers: [ACCEPT:ACCEPT_TYPE]).responseJSON { (response) in
            print(url.absoluteURL)
                switch response.result {
                    
                case .success(let value):
                    print("autologin-> \(response.description)")
                    
                    guard let dictionary = value as? [String: Any] else {
                        completionHandler(nil, nil, nil)
                        return
                    }
                    
                    if dictionary.keys.contains("error") {
                        Alerts.displayAlert(with: "Error", and: "User maybe not found")
                        completionHandler(nil, nil, nil)
                        return
                    }
    
                 
                    guard let dic = dictionary["token"] as? [String: Any] else {
                        return
                    }
                    
                    print(dic)
                   // let encoder = JSONEncoder()
                 //   let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)

//                    guard  let data = try? encoder.encode(dic) else {
//                        return
//                    }
                    
                    guard let data = try? JSONSerialization.data(
                        withJSONObject: dic,
                        options: []) else { return }
                        
                
                   //guard let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) else { return }

                   
                    

                    do {
                        let jobManager = try JSONDecoder().decode(JobManager.self, from: data)
                        let userObject = try JSONDecoder().decode(User.self, from: data)
                        completionHandler(userObject, jobManager.jobId, nil)
                      //  completionHandler(userObject, "", nil)

                    }
//                    catch let error {
//                        print(error.localizedDescription)
//                        completionHandler(nil, nil, error as NSError)
//                    }
                 catch let DecodingError.dataCorrupted(context) {
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
                     //   completionHandler(nil, nil,  NSError)

                    
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        // timeout error statement
                        completionHandler(nil, nil, error as NSError)
                        Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
                        //viewController?.presentAlert(withTitle: Constants.ERROR_TITLE, message: (response.result.error?.localizedDescription)!)
                    } else {
                        // other error statement
                        completionHandler(nil, nil, error as NSError)
                    }
                }
            }
            
//        } else {
//            Alerts.alert(with: nil, for: "Add phone identifier first", with: "Missing info")
//        }
    }
    
    func  postLogForCrowdSource(params:[String: Any], completionHandler: @escaping (Bool?, NSError?) -> ()) {
        
        
       // let udid = UIDevice.current.identifierForVendor!.uuidString
        let param =  params
        let url = AppEnvoriment.shared.apiBaseUrl + POST_EQUIPMENT_LOG
        print(url)
        Alamofire.request(URL(string: AppEnvoriment.shared.apiBaseUrl + POST_EQUIPMENT_LOG)!, method: .post, parameters: param, encoding: JSONEncoding.default, headers:[ACCEPT:ACCEPT_TYPE] ).responseJSON { (response) in
            print(response.debugDescription)
            if response.result.isSuccess  {
                if response.response?.statusCode == 200 {//self.OK_CODE {
                    //if expected response send it
                    completionHandler(true,nil)
                } else {
                    //send nils to evaluate on handler
                    completionHandler(false, nil)
                }
            } else {
                completionHandler(nil, nil)
                Alerts.alert(with: nil,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
            }
        }
        
    }
    
}
