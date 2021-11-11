//
//  NetworkManager.swift
//  NovaTrack
//
//  Created by developer on 5/13/19.
//  Copyright © 2019 Paul Zieske. All rights reserved.
//

import UIKit
import UserNotifications
import ReachabilitySwift
import NotificationBannerSwift
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

enum NetworkConnection: String {
    case wifi
    case cellular
    case none
}


class NetworkManager: NSObject {
   
    static  let shared = NetworkManager()  // 2. Shared instance
    var conectionBy : NetworkConnection = .none
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool = false
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    // 5. Reachability instance for Network status monitoring
    var reachability = Reachability()!
    
    typealias networkClousure = (Bool) -> Void
    private var closuresCollection: [networkClousure] = []
   // private var networkConnectionDidChange: networkClousure!
    
//    var  currentSSID : String? {
//        get {
//            guard let info : NetworkInfo = getNetworkInfos().first else { return SettingsBundleHelper.shared.isProductionEnabled ? nil : Constants.stagingSSID }
//            return info.ssid
//        }
//        set {
//
//        }
//    }
//
//    var  currentBSSID : String? {
//        get {
//            guard let info : NetworkInfo = getNetworkInfos().first else { return nil }
//            print(info.bssid)
//            return info.bssid
//        }
//        set {
//
//        }
//    }
//
//    var  currentInterface : String? {
//        get {
//            guard let info : NetworkInfo = getNetworkInfos().first else { return nil }
//            print(info.interface)
//            return info.interface
//        }
//        set {
//
//        }
//    }
    
    func networkDidchange(network: @escaping networkClousure) {
        self.closuresCollection.append(network)
    }
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        
        
        switch reachability.currentReachabilityStatus {

        case .notReachable:

            debugPrint("Network reachable NO")
            conectionBy = .none
            self.isNetworkAvailable = false
         //   resetNetworkInfo()
            
           

        case .reachableViaWiFi:

            debugPrint("Network reachable through WiFi")
            conectionBy = .wifi
            self.isNetworkAvailable = true

            

        case .reachableViaWWAN:
            
            debugPrint("Network reachable through Cellular Data")
            conectionBy = .cellular
            self.isNetworkAvailable = true

        }
        
      //  NetworkNotificationsManager.shared.fireBanner(reachability: reachability)
       runAllClousures()

        
    }
    
    func runAllClousures() {
        for clousure in self.closuresCollection {
            clousure(self.isNetworkAvailable)
        }

    }
    
     func sendLocalNotification(title: String, subtitle: String, body: String) {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.subtitle = subtitle
        notification.body = body
        notification.sound = UNNotificationSound.default
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification2", content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func sendLocalNotificationWithUserInfo(title: String, subtitle: String, body: String, userInfo: [String: Any]) {
       let notification = UNMutableNotificationContent()
       notification.title = title
       notification.subtitle = subtitle
       notification.body = body
    
        notification.userInfo = userInfo
       notification.sound = UNNotificationSound.default
       let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
       let request = UNNotificationRequest(identifier: "notification2", content: notification, trigger: notificationTrigger)
       UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
    
//    func isSSIDNamesEmpty() -> Bool {
//        
//        if SettingsBundleHelper.shared.SSIDNames.count == 0 {
//            
//            UIApplication.shared.getTopThreadSafe { (topViewController) in
//                 guard let topViewController = topViewController else { return }
//                           
//                if !SessionManager.shared.isAppInBackground {
//                               let banner = NotificationBanner(title: "Important!", subtitle: "You have not set network names", style: .danger)
//                               banner.show(queuePosition: .front, bannerPosition: .top, queue: .default, on: topViewController)
//                           }
//                           if SessionManager.shared.allowNotifications && SessionManager.shared.isAppInBackground  {
//                               self.sendLocalNotification(title: "Important!", subtitle: "Network", body: "You have not set network names")
//                           }
//            }
//           
//            
//            return true
//            
//        } else {
//        return false
//        }
//    }
    
//    func resetNetworkInfo() {
//        self.currentSSID = nil
//        self.currentBSSID = nil
//        self.currentInterface = nil
//    }
    
//    func isWiFiOn() -> Bool {
//        var address : String?
//        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            var ptr = ifaddr
//            while ptr != nil {
//                defer { ptr = ptr?.pointee.ifa_next }
//                let interface = ptr?.pointee
//                let addrFamily = interface?.ifa_addr.pointee.sa_family
//                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//
//                     let name: String = String(cString: (interface?.ifa_name)!)
//                    if name == "awdl0" {
//
//                                               //UInt32  interface?.ifa_flags
//                               //Int32
//
//                        if((interface!.ifa_flags & UInt32(IFF_UP)) == UInt32(IFF_UP)) {
//                            return(true)
//                        }
//                        else {
//                            return(false)
//                        }
//                    }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
//        return (false)
//    }
    
    func conectionByToString() -> String {
        switch self.conectionBy {
        case .none:
            return "none"
        case .cellular:
            return "cellular"
        case .wifi:
            return "wifi"
        }
    }
    
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
   /* func getWiFiAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {

            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr.memory.ifa_next }

                let interface = ptr.memory

                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface.ifa_addr.memory.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // Check interface name:
                    if let name = String.fromCString(interface.ifa_name) where name == "en0" {

                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.memory.sa_len),
                                    &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST)
                        address = String.fromCString(hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }

        return address
    }*/

    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        func stopMonitoring(){
            reachability.stopNotifier()
            NotificationCenter.default.removeObserver(self,
                                                      name: ReachabilityChangedNotification,
                                                      object: reachability)
        }
    }
               
    func getWiFiSsid() -> String? {
           var ssid: String?
           if let interfaces =  CNCopySupportedInterfaces() as NSArray? {
               for interface in interfaces {
                   if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                       ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                       break
                   }
               }
           }
           return ssid
       }
    
//    func isConnectedToValidNetwork() -> Bool {
//        guard let currentSSID = self.currentSSID else { return false }
//           if SettingsBundleHelper.shared.SSIDNames.contains(currentSSID) {
//               return true
//           } else {
//               return false
//           }
//       }
               
}
