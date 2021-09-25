//
//  BroadcastManager.swift
//  NovaTrack
//
//  Created by developer on 3/30/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import UIKit
import SocketIO


class BroadcastManager {
    
    static let shared = BroadcastManager()
    //    private let manager:SocketManager
    //    private let socket:SocketIOClient
    var didBroadcast: (()->Void)?
    var messages: [String] {
        get {
            guard let broadcastMessages = UserDefaults.standard.array(forKey: "broadcastMessages") as? [String] else { return [] }
            return broadcastMessages
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "broadcastMessages")
        }
        
    }
    
    var messagesCountForAppIconBadge: Int {
        get {
             let broadcastMessagesCount = UserDefaults.standard.integer(forKey: "broadcastMessagesCount")
            return broadcastMessagesCount
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "broadcastMessagesCount")
        }
        
    }
    
    private init() {
        //        self.manager = SocketManager(socketURL: URL(string: "https://itxlin09.itexico.com/socket.io")!, config: [.log(true), .secure(true), .security(SSLSecurity(usePublicKeys: true)), .forceNew(true), .reconnectWait(60)])
        //        self.socket = manager.socket(forNamespace: "/")
        self.addHandlers()
    }
    
    func listen() {
        print("init")
    }
    
    func addHandlers(){
        
        //    manager.defaultSocket.on(clientEvent: .connect) {data, ack in
        //           print("🦷 Socket connected:\(data)\n \(ack)")
        //    }
        //
        //    manager.defaultSocket.on(clientEvent: .disconnect) {data, ack in
        //           print("🐼 Socket disconnected: \(data)\n \(ack)")
        //        //self.socketMessages.disconnect()
        //        self.socket.disconnect()
        //    }
        //
        //    manager.defaultSocket.on(clientEvent: .error) {data, ack in
        //        print("\nSocket error: \(data)\n \(ack)")
        //    }
//
//        SocketIOManager.sharedInstance.manager.defaultSocket.on("broadcast-susbcribe") { (data, ack) in
//           // print("broadcast-susbcribe \(data) + \(ack)")
//            self.checkIncomingMessageToBroadcast(data: data)
//        }
//
//        SocketIOManager.sharedInstance.socket.on("broadcast-susbcribe") { (data, ack) in
//                 //  print("broadcast-susbcribe \(data) + \(ack)")
//                   self.checkIncomingMessageToBroadcast(data: data)
//               }
        
        ChatManager.shared.socket?.on("broadcast-susbcribe") { (data, ack) in
            print("🏓🏓 broadcast-susbcribe \(data) + \(ack)")
            self.checkIncomingMessageToBroadcast(data: data)
        }
        
        ChatManager.shared.socket?.on("recieve broadcast") { (data, ack) in
            print("🏓🏓 broadcast-susbcribe \(data) + \(ack)")
            self.checkIncomingMessageToBroadcast(data: data)
        }

        
    }
    
    
    func checkIncomingMessageToBroadcast(data: [Any]) {
        guard let responce: [String: Any] = data.first as? [String : Any] else { return }
        print(responce)
        guard let type = responce.valueForKeyPath(keyPath: "type") as? String else { return }
        
        if type == MessagesTypes.broadcast.rawValue {
            
            var messageToDisplay = "Sent by: "
            
            
            if let dictionary = responce.valueForKeyPath(keyPath: "message") as? [String : Any] {
                
                if let userName = dictionary["user"] as? String {
                    messageToDisplay += userName
                }
                

                
                if let message = dictionary.valueForKeyPath(keyPath: "message") as? String {
                    messageToDisplay += "\n\(message)"
                    self.messages.append(message)
                }
                
               
            }
            
            
            if SessionManager.shared.isAppInBackground {
                
                let currentBardgeNumber = UIApplication.shared.applicationIconBadgeNumber
                //UIApplication.shared.applicationIconBadgeNumber = currentBardgeNumber + 1
                //self.messagesCountForAppIconBadge = currentBardgeNumber + 1
                
                self.didBroadcast?()
                
            } else {
                
                UIDevice.notifyWarningWithSound()
                Alerts.displayAlertWithCompletion(title: "BROADCAST", and: messageToDisplay) {
                    print("Ya se fue")
                    
                    let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                    
                 //   if let drawerController = rootViewController as? KYDrawerController {
                        if let navigationController = rootViewController as? UINavigationController {
                            if let tabViewcontroller = navigationController.viewControllers.first as? UITabBarController {
                                print("yes")
                                tabViewcontroller.selectedIndex = 0
                                
                                if let navigation = tabViewcontroller.viewControllers?.first as? UINavigationController {
                                    
                                    if let chatContactsViewController = navigation.viewControllers.first as? ChatContactsViewController {
                                        print("yes")
                                        
                                        chatContactsViewController.goToBroadCastMessages(animated: false)
                                    }
                                    
                                }
                            }
                        }
                }
            }
            
        }
    }
    
}



