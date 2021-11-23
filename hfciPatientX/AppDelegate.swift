//
//  AppDelegate.swift
//  hfciPatientX
//
//  Created by user on 13/09/21.
//

import UIKit
import UserNotifications
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //SettingsBundleHelper.shared.setInitialInfo()
        SettingsBundleHelper.shared.hospitalCode = "henryford"
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (succes, error) in
            if succes {
            print("notifications granted")
                self.configureUserNotifications()
            }
        }
               
        SettingsBundleHelper.shared.addObserverEnvoriment()
      //  asignBeaconToPainting()
       // asignPaintingToBeacon()
      //  asigBeaconsToPaintings()
        
      //  NotificationCenter.default.post(name: NSNotification.Name(Notifications.newMessage), object: self, userInfo: ["message":newMessage])
        NotificationCenter.default.addObserver(forName: NSNotification.Name(ChatManager.Notifications.newMessage), object: nil, queue: .main) { [weak self] notification in
            
            if let message = notification.userInfo?["message"] as? Message {
                print("Got new message: \(message)")
               // if self?.navigationController?.viewControllers.count == 1,
                  if  let contact = ChatManager.shared.getUser(message.origin) {
                      self?.contact = contact
                  }
//                    self?.setUnreadMessages(contact.id, contact.unreadMessages + 1)
//                }
//                self?.setAsRecent(message.origin)
            }
        }

        return true
    }
    
    var contact: ChatUser?
   
    
    func asignBeaconToPainting() {
        for (index, beacon) in beacons.enumerated() {
            beacon.location = paintings[index].location
            paintings[index].beacon = beacon
        }
    }
    
   
    func asignPaintingToBeacon() {
        for (index, beacon) in beacons.enumerated() {
            beacon.paintings.append(paintings[index])
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
      //  let userInfo = response.notification.request.content.userInfo
       // print(userInfo)
        
      //  if let userInfo = notification.userInfo {
        if let contact = self.contact {
               // print(newMessage)
              NotificationCenter.default.post(name: Notification.Name("NewChatMessage"), object: nil, userInfo: ["Message":contact])

               // self.containerView.bringSubviewToFront(self.chatViewController.view)
            }
      //  }
      //  NotificationCenter.default.post(name: Notification.Name("NewChatMessage"), object: nil, userInfo: ["Message":newMessage])

       /* if response.notification.request.identifier == "NewMessage" {
            NotificationCenter.default.post(name: NSNotification.Name(ChatManager.Notifications.notificationTapped), object: self, userInfo: response.notification.request.content.userInfo)
        }
        else if response.notification.request.identifier == "LocationServicesAuthStatusNotification" {
            if let settingsUrl = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        else if response.actionIdentifier == BeaconTracingManager.shared.muteActionId {
            BeaconTracingManager.shared.handleSilenceNotification(response: response)
        }
        else {
            NetworkNotificationsManager.shared.handleDidReceiveNotification(response)
        }
        
       
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)
        
        if let type = userInfo["type"] as? String {
           
            if type == "message" {
                 
            
               if let role = userInfo["role"] as? String,
                let status = userInfo["status"] as? String,
                let name = userInfo["name"] as? String,
                let unreadMsgs = userInfo["unreadMsgs"] as? String,
                let id = userInfo["id"] as? String,
                let channel = userInfo["channel"] as? String,
                let campusId = userInfo["campusId"] as? String,
                let roleName = userInfo["role_name"] as? String {
//                var rootViewController = self.window?.rootViewController
//                if let tabBarController = rootViewController as? UITabBarController {
//                    if let showingView = tabBarController.selectedViewController as? UINavigationController {
//
//                        let messagesVC = MessagesViewController()
//
//                        showingView.pushViewController(messagesVC, animated: true)

                let chatUser = ChatUser(id: id, channel: channel, fullName: name, firstName: "", lastName: "", initials: "", roleName: roleName, status: .offline, unreadMessages: Int(unreadMsgs) ?? 0)
                
                let rootViewController = self.window?.rootViewController
                if let tabBarController = rootViewController as? UITabBarController {
                    tabBarController.selectedIndex = 0
                    let messagesVC = MessagesViewController()
                    messagesVC.contactUser = chatUser
                    if let showingView = tabBarController.selectedViewController as? UINavigationController {
                        showingView.pushViewController(messagesVC, animated: false)
                    }
                        
                }
            
               }
                
            } else if  type == "broadcast"   {
                
                if let _ = userInfo["origin"] as? String,
                 let name = userInfo["fullName"] as? String,
                 let id = userInfo["id"] as? String {
                
               let chatUser = ChatUser(id: id, channel: "", fullName: name, firstName: "", lastName: "", initials: "", roleName: "", status: .online, unreadMessages: 0)
                
                let rootViewController = self.window?.rootViewController
                if let tabBarController = rootViewController as? UITabBarController {
                    tabBarController.selectedIndex = 0
                    let messagesVC = MessagesViewController()
                    messagesVC.contactUser = chatUser
                    if let showingView = tabBarController.selectedViewController as? UINavigationController {
                        showingView.pushViewController(messagesVC, animated: false)
                    }
                        
                }
                }
            }
                
        }
        
        
     
//           if let pushText = userInfo["alert"] as? String {
//           }
        
        completionHandler()
        */
        completionHandler()

    }
}
