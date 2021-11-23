//
//  ChatManager.swift
//  NovaTrack
//
//  Created by Juan Pablo Rodriguez Medina on 03/03/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//HFCI

import Foundation
import SocketIO
import UserNotifications

struct BroadcastUser {
    static let id = "111111111111111111111111"
    static let destiny = "222222222222222222222222"
}

class ChatManager {
    
    struct Events {
        static let join = "join"
        static let joined = "joined"
        static let disconnect = "disconnect"
        static let disconnected = "user disconnect"
        static let logoutUser = "logoutUser"
        static let users = "users"
        static let initialUsers = "initialUsers"
        static let sendMessage = "send message"
        static let newMessage = "new message"
        static let messages = "messages"
        static let setMessageRead = "set message read"
        static let messageSent = "message sent"
    }
    
    struct Notifications {
        static let newMessage = "newChatMessage"
        static let messageSent = "messageSent"
        static let notificationTapped = "notificationTapped"
    }
    
    struct MessagesData: SocketData {
        
        let destiny:String
        let origin:String
        
        func socketRepresentation() -> SocketData {
            return ["destiny":self.destiny, "origin":self.origin]
        }
    }
    
    
    static let shared = ChatManager()
    //  private let baseUrl = "ws://localhost:3050/"
    // private let baseUrl = "https://itxlin09.itexico.com/chat"
    //let envoriment = SocketIOEndPoint()
    // let baseUrl = SocketIOManager.sharedInstance.envoriment.getCurrentStateEndPoint()
    
    
    
    var manager:SocketManager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketChat)!, config: [.compress, .path(SocketIOEnvoriment.pathSocketChat), .reconnectWait(5), .secure(true), .security(SSLSecurity(usePublicKeys: true))])
     var socket: SocketIOClient?
    
    var usersDict:[String:ChatUser]?
    var currentUser:ChatUser?
    var socketId:String? {
        return self.socket?.sid
    }
    var isSocketIOChatEnabled = "NO STATUS"
    var isChatSocketIOEnabled = false
    var isPaginating = false
    var didJoin = false
    var didLoadAll = false
    var didGetNewMessage:((Message) -> Bool)?
    var userDidChangeStatus:((_ oldStatusUser:ChatUser?, _ newStatusUser:ChatUser) -> Void)?
    var didSendMessage:((_ message:Message) -> Void)?
    var didNewUserConnect:((_ newUser:ChatUser) -> Void)?

    init() {
        
    //    print("🍀🦷 chat init url: \(SocketIOEnvoriment.envorimentSocketChat)")
        //print("🍀🦷 chat init path:\(SocketIOEnvoriment.pathSocketChat)")

//        self.manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketChat)!, config: [.compress, .path(SocketIOEnvoriment.pathSocketChat), .reconnectWait(5), .secure(true), .security(SSLSecurity(usePublicKeys: true))])
//        self.socket = self.manager.socket(forNamespace: "/chat")
//        self.setEventsCallbacks()
      
    }
    
    func setup() {
        
        //print("🍀🦷 chat setup url: \(SocketIOEnvoriment.envorimentSocketChat)")
        //print("🍀🦷 chat setup path:\(SocketIOEnvoriment.pathSocketChat)")
        
        //Uncomment this line when you are pointing to yuor local
       // self.manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketChat)!, config: [.compress, .reconnectWait(5), .secure(false), .security(SSLSecurity(usePublicKeys: false))])
        
           self.manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketChat)!, config: [.compress, .path(SocketIOEnvoriment.pathSocketChat), .reconnectWait(5), .secure(true), .security(SSLSecurity(usePublicKeys: true))])
                 
        self.socket = self.manager.socket(forNamespace: "/chat")
                  self.setEventsCallbacks()
        self.establishConnection()

    }
    
    func switchEnvoriment() {
            
        //print("🍀🦷 chat switch setup url: \(SocketIOEnvoriment.envorimentSocketChat)")
        //print("🍀🦷 chat switch setup path:\(SocketIOEnvoriment.pathSocketChat)")
          print("🍀 🚨🚨 start switch chat \(SocketIOEnvoriment.envorimentSocketChat)")

        self.disconnect()
        
        //Uncomment this line when you are pointing to yuor local
       // self.manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketChat)!, config: [.compress, .reconnectWait(5), .secure(false), .security(SSLSecurity(usePublicKeys: false))])
     
//        self.manager = SocketManager(socketURL: URL(string: SocketIOEnvoriment.envorimentSocketChat)!, config: [.compress, .path(SocketIOEnvoriment.pathSocketChat), .reconnectWait(5), .secure(true), .security(SSLSecurity(usePublicKeys: true))])
//               self.socket = self.manager.socket(forNamespace: "/chat")
       self.setup()

    //  self.establishConnection()
        guard let userId = SessionManager.shared.user?.userId else { return }

//        self.join(userId: userId) { (succes) in
//            //print("succes")
//        }
       
           
           print("🍀 🚨🚨 finish switch chat")

       }
    
   
    
    func establishConnection() {
        socket?.connect()
        manager.connect()
        //  socketMessages.connect()
    }
    
    
    func closeConnection() {
        socket?.disconnect()
        manager.disconnect()
        //   socketMessages.disconnect()
    }
    
    func addBroadcastUser(data: [String: ChatUser]) {
        for (key, value) in data {
            self.usersDict?[key] = value
        }
    }
    
    private func setEventsCallbacks() {
        
        self.socket?.on(clientEvent: .connect) { [weak self] (data, ack) in
            let description = "connect status:\(String(describing: self?.socket?.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            
        //    print("🍀 ✅ chat \(description)")
            //print("⚠️✅ chat \(String(describing: self?.socket?.sid))")

            self?.isSocketIOChatEnabled = description
          //  NetworkNotificationsManager.sendLocalNotificationForSocketIOStatus(title: "Connect", subtitle: "Scoket IO Chat", body: description)
            let descriptionSocket = "\(true) connect status:\(String(describing: self?.socket?.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            print("🍀 ✅ CHAT | socketURL: \(String(describing: self?.manager.socketURL)) | socketId:  \(String(describing: self?.socket?.sid))) |  envoriments: \(SocketIOEnvoriment.envorimentSocketLocation) | path: \(SocketIOEnvoriment.pathSocketLocation)  | chat \(descriptionSocket)")
            NotificationCenter.default.post(name: Notification.Name("didSocketConnect"), object: nil)


//            guard let userId = SessionManager.shared.user?.userId else { return }
//            guard let id = self?.socket?.sid else { return }
//            let payload = JoinData(userId: userId, socketId: id, firebaseToken: SessionManager.shared.firebaseToken ?? "")
//            
//            
//
//            self?.socket?.emit(Events.join, payload) {
//                self?.socket?.emit(Events.users)
//                self?.socket?.on(Events.users, callback: { [weak self] data, ack in
//                    print(data)
//                    let users = self?.parseUsers(from: data)
//                    self?.usersDict = users
//                    self?.currentUser = users?[userId]
//                  //  completion(true)
//                    NotificationCenter.default.post(name: Notification.Name("didSocketConnect"), object: nil)
//
//                })
//                
//              //  completion(true)
//
//                
//            }
        }
        
        self.socket?.on(clientEvent: .error) {  [weak self] (data, ack) in
            let description = "\(false) error status:\(String(describing: self?.socket?.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            //print("🍀 chat error \(description)")
            
            self?.isSocketIOChatEnabled = description
          //  NetworkNotificationsManager.sendLocalNotificationForSocketIOStatus(title: "Error", subtitle: "Scoket IO Chat", body: description)
            if self?.socket?.status == .connected {
                self?.establishConnection()
            }
            
        }
        
        
        
        socket?.on(clientEvent: .disconnect) { [weak self] (data, ack) in
            
            let description = "\(false) disconnect status:\(String(describing: self?.socket?.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            
            //print("🍀 chat disconnect \(description)")
            
            self?.isSocketIOChatEnabled = description
          //  NetworkNotificationsManager.sendLocalNotificationForSocketIOStatus(title: "Error", subtitle: "Scoket IO Chat", body: description)
            
            //  self.socketMessages.disconnect()
            self?.socket?.disconnect()
        }
        
        socket?.on("bcst-messages") { (data, ack) in
            print("🏓🏓 broadcast-susbcribe \(data) + \(ack)")
            //self.checkIncomingMessageToBroadcast(data: data)
        }
        
//        socket?.connect(timeoutAfter: 1.0) {
//            let description = "timeoutAfter: 1.0 status:\(String(describing: self.socket?.status)) date:\(Date().stringFromDateZuluFormat())"
//            //print("🍀 chat \(description)")
//        }
        
        socket?.on(clientEvent: .reconnect) { [weak self] (data, ack) in
            let description = "\(false) reconnect status:\(String(describing: self?.socket?.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            //print("🍀 chat \(description)")
            
            self?.isSocketIOChatEnabled = description
          //  NetworkNotificationsManager.sendLocalNotificationForSocketIOStatus(title: "Error", subtitle: "Scoket IO Chat", body: description)
            
        }
        
        socket?.on(clientEvent: .reconnectAttempt) { [weak self] (data, ack) in
            let description = "\(false) reconnectAttempt status:\(String(describing: self?.socket?.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            //print("🍀 chat \(description)")
            
            self?.isSocketIOChatEnabled = description
         //   NetworkNotificationsManager.sendLocalNotificationForSocketIOStatus(title: "Error", subtitle: "Scoket IO Chat", body: description)
            
            
        }
        
        socket?.on(clientEvent: .ping) { [weak self] (data, ack) in
            
            _ = "ping chat status:\(String(describing: self?.socket?.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            //print("🍀⚾️ chat \(description)")
            
        }
        
        socket?.on(clientEvent: .pong) { [weak self] (data, ack) in
            
            _ = "pong chat status:\(String(describing: self?.socket?.status)) data:\(data) date:\(Date().stringFromDateZuluFormat())"
            //print("🍀⚾️ chat \(description)")
            
        }
        
        self.socket?.on(Events.joined, callback: { [weak self] data, ack in
            print("🤩 \(data)")
            if let user = self?.parseUser(from: data) {
                print("🤩 \(user)")
                if let oldStatusUser = self?.usersDict?[user.id] {
                self?.usersDict?[user.id] = user
                self?.userDidChangeStatus?(oldStatusUser, user)
                } else {
                    self?.usersDict?[user.id] = user
                    self?.didNewUserConnect?(user)
                }
            }
        })
        
        self.socket?.on(Events.disconnected, callback: { [weak self] data, ack in
           print(data)
            if let user = self?.parseUser(from: data) {
                let oldStatusUser = self?.usersDict?[user.id]
                self?.usersDict?[user.id] = user
                self?.userDidChangeStatus?(oldStatusUser, user)
            }
        })
        
        self.socket?.on(Events.logoutUser, callback: { [weak self] data, ack in
           print(data)
            if let user = self?.parseUser(from: data) {
                let oldStatusUser = self?.usersDict?[user.id]
                self?.usersDict?[user.id] = user
                self?.userDidChangeStatus?(oldStatusUser, user)
            }
        })
        
        self.socket?.on(Events.newMessage, callback: { [weak self] data, ack in
            if let newMessage = self?.parseNewMessage(from: data) {
             //  NotificationCenter.default.post(name: Notification.Name("NewChatMessage"), object: nil, userInfo: ["Message":newMessage])
                NotificationCenter.default.post(name: NSNotification.Name(Notifications.newMessage), object: self, userInfo: ["message":newMessage])
              //  NetworkManager.shared.sendLocalNotificationWithUserInfo(title: "New Message", subtitle: "", body: newMessage.text, userInfo: ["Message":["id":newMessage.id, "": "channel": newMessage.channel, "fullName": newMessage.origin]])
                NetworkManager.shared.sendLocalNotification(title: "New Message", subtitle: "", body: newMessage.text)
                if self?.didGetNewMessage?(newMessage) ?? true {
                    self?.sendNewMessageNotification(newMessage)
                }
            }
        })
        
        self.socket?.on(Events.messageSent, callback: { [weak self] data, ack in
            //print("Message sent: \(data)")
            NotificationCenter.default.post(name: NSNotification.Name(Notifications.messageSent), object: self, userInfo: nil)
        })
        
        self.socket?.on(Events.setMessageRead, callback: { [weak self] data, ack in
                print("Message sent: \(data)")
        })
        
        self.socket?.on(Events.messages, callback: { [weak self] data, ack in
            print("Message sent: \(data)")
        })
        
    }
    
   
    
    private func parseUsers(from data:[Any]) -> [String:ChatUser]? {

        do {
            if let rawUsers = (data.first as? [String:Any])?["users"] as? [String:Any] {
                
                let data = try JSONSerialization.data(withJSONObject: rawUsers, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                
                let usersDict = try jsonDecoder.decode([String: FailableDecodable<ChatUser>].self, from: data)
                    .compactMapValues({ $0.value })
                //Maybe here
                return usersDict
            }
        }
        catch(let error) {
            print("Error decoding users: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func parseUser(from data:[Any]) -> ChatUser? {
        
        do {
            if let rawUser = data.first as? [String:Any] {
                
                let data = try JSONSerialization.data(withJSONObject: rawUser, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                
                let user = try jsonDecoder.decode(FailableDecodable<ChatUser>.self, from: data).value
                return user
            }
        }
        catch(let error) {
            print("Error decoding user: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func parseMessages(from data:[Any]) -> [Message]? {
        do {
            if let messages = (data.first as? [String:Any])?["messages"] as? [[String:Any]] {
               // print(messages)
                let data = try JSONSerialization.data(withJSONObject: messages, options: .prettyPrinted)
                let jsonDecoder = JSONDecoder()
                let failableMessages = try jsonDecoder.decode([FailableDecodable<Message>].self, from: data)
                let messages = failableMessages.compactMap({ $0.value })
                return messages
            }
        }
        catch let error {
            print("Error decoding messages: \(error)")
        }
        return nil
    }
    private func parseNewMessage(from data:[Any]) -> Message? {
        print(data)
        do {
            if let message = (data.first as? [String:Any])?["newMessage"] as? [String:Any] {
                let data = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
                
                print(message)
                let jsonDecoder = JSONDecoder()
                let failableMessage = try jsonDecoder.decode(FailableDecodable<Message>.self, from: data)
                let messageL = failableMessage.value
                
                let currentBardgeNumber = UIApplication.shared.applicationIconBadgeNumber
                //UIApplication.shared.applicationIconBadgeNumber = currentBardgeNumber + 1
                
                return messageL
            }
        }
        catch let error {
            print("Error decoding messages: \(error)")
        }
        return nil
    }
    
    func join(userId:String, completion: @escaping (_ success:Bool) -> Void) {
       
        self.socket?.connect(timeoutAfter: 15) {
            completion(false)
        }
        
        
      //  self.socket?.on(clientEvent: .connect, callback: { [weak self] data, ack in
            guard let id = self.socket?.sid else { return }
            let payload = JoinData(userId: userId, socketId: id, firebaseToken: SessionManager.shared.firebaseToken ?? "")
            
            

            self.socket?.emit(Events.join, payload) {
                self.socket?.emit(Events.users)
                self.socket?.on(Events.users, callback: { [weak self] data, ack in
                    print("⚡️\(data)")
                    let users = self?.parseUsers(from: data)
                    self?.usersDict = users
                    self?.currentUser = users?[userId]
                    completion(true)
                })
                
              //  completion(true)

                
            }
     //   })
    }
    
    func getInitialUsers(userId:String, completion: @escaping (_ success:Bool) -> Void) {
        

        self.socket?.connect(timeoutAfter: 15) {
            completion(false)
        }
        
        
       // self.socket?.on(clientEvent: .connect, callback: { [weak self] data, ack in
            guard let id = self.socket?.sid else { return }
            let payload = JoinData(userId: userId, socketId: id, firebaseToken: SessionManager.shared.firebaseToken ?? "")
            
            

           self.socket?.emit(Events.join, payload) {
//                self?.socket?.emit(Events.users)
//                self?.socket?.on(Events.users, callback: { [weak self] data, ack in
//                    print(data)
//                    let users = self?.parseUsers(from: data)
//                    self?.usersDict = users
//                    self?.currentUser = users?[userId]
//                    completion(true)
//                })
            self.didJoin = true
                //Initial Users
                self.socket?.emit(Events.users)
                self.socket?.on(Events.users, callback: { [weak self] data, ack in
                    print(data)
                    let users = self?.parseUsers(from: data)
                    self?.usersDict = users
                    self?.currentUser = users?[userId]
                    completion(true)
                   
                })
                
            }
       // })
            
      
    }
    
    func emitForMoreUsers(userId:String, completion: @escaping (_ success:Bool) -> Void) {
        

        self.socket?.emit(Events.users)
        self.isPaginating = true
        self.socket?.on(Events.users, callback: { [weak self] data, ack in
            print(data)
                         let users = self?.parseUsers(from: data)
                         self?.usersDict = users
                         self?.currentUser = users?[userId]
                         completion(true)
            self?.isPaginating = false
            self?.didLoadAll = true
                     })
    }
    
    func getUsersWithEmit(userId:String, completion: @escaping (_ success:Bool) -> Void) {
        guard let id = self.socket?.sid else { return }
        let payload = JoinData(userId: userId, socketId: id, firebaseToken: SessionManager.shared.firebaseToken ?? "")
                            self.socket?.emit(Events.join, payload) { [weak self] in
                                self?.socket?.emit(Events.users)
                                self?.socket?.on(Events.users, callback: { [weak self] data, ack in
                                    print(data)
                                    let users = self?.parseUsers(from: data)
                                    self?.usersDict = users
                                    self?.currentUser = users?[userId]
                                    completion(true)

                                })
                            }
    }
    
        
    func disconnect() {
        if self.socket?.status == .connected {
            self.socket?.emit(Events.disconnect)
            self.socket?.disconnect()
        }
    }
    
    func getUser(_ userId:String) -> ChatUser? {
        return ChatManager.shared.usersDict?[userId]
    }
    
    func getMessages(withUser contactId:String, completion: @escaping ([Message]?) -> Void) {
        func emitAndHandleMessages() {
            if let userId = self.currentUser?.id {
                let payload: MessagesData
                payload = contactId == BroadcastUser.id ? MessagesData(destiny: BroadcastUser.destiny, origin: contactId) : MessagesData(destiny: contactId, origin: userId)
                print(payload)
                self.socket?.emit(Events.messages, payload)
                self.socket?.on(Events.messages, callback: {[weak self] data, ack in
                    print(data)
                    let messages = self?.parseMessages(from: data)
                    completion(messages)
                })
            }
        }
        
        
        if self.socket?.status == .connected {
            emitAndHandleMessages()
        }
        else {
            self.socket?.on(clientEvent: .connect, callback: { data, ack in
                print(data)
                if self.socket?.status == .connected {
                    emitAndHandleMessages()
                }
                else {
                    completion(nil)
                }
            })
        }
    }
    
    func sendMessage(_ messageText:String, destinyUser:ChatUser) -> Message? {
        if let userId = self.currentUser?.id {
            let addName = "@\(SessionManager.shared.userName ?? ""), "
            //text: addName + messageText
            let message = Message(id: "", text: addName + messageText, origin: userId, destiny: destinyUser.id, status: 0, channel: destinyUser.channel, creationDate: Date(), seen: false)
            self.socket?.emit(Events.sendMessage, message)
            
            let messageTwo = Message(id: "", text: messageText, origin: userId, destiny: destinyUser.id, status: 0, channel: destinyUser.channel, creationDate: Date(), seen: false)
            
            self.didSendMessage?(message)
            
            
            return messageTwo
        }
        return nil
    }
    
    func sendMessage(_ messageText:String, destinyId:String) -> Message? {
        if let user = self.getUser(destinyId) {
            return self.sendMessage(messageText, destinyUser: user)
        }
        return nil
    }
    
    func sendNewMessageNotification(_ message:Message) {
//        if let originUser = self.getUser(message.origin) {
//            let content = UNMutableNotificationContent()
//            content.title = originUser.fullName
//            content.sound = .default
//            content.body = message.text
//            content.userInfo = ["originId":message.origin]
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let request = UNNotificationRequest(identifier: "NewMessage", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request) { (error) in
//                print("Local notification sent, error: \(error?.localizedDescription ?? "")")
//            }
//        }
    }
    
    func setMessagesAsRead(destiny: String, completion: @escaping ()->()) {
        print(destiny)
        self.socket?.emit("set message read", with: [destiny], completion: {
            completion()
        })
    }
    
    func emitToReloadUser() {
           self.socket?.emit(Events.users)
       }

}

struct JoinData: SocketData {
    
    let userId:String
    let socketId:String
    let firebaseToken: String
    
    func socketRepresentation() -> SocketData {
        return ["userId":self.userId, "socketId":self.socketId, "firebaseToken": firebaseToken]
    }
}
