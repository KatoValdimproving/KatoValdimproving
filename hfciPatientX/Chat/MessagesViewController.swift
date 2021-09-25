//
//  MessagesViewController.swift
//  NovaTrack
//
//  Created by Juan Pablo Rodriguez Medina on 06/03/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import UIKit
import MessengerKit
import IQKeyboardManagerSwift

class MessagesViewController: MSGMessengerViewController {
    
    struct MessageUser: MSGUser {
        var displayName: String
        var avatar: UIImage?
        var isSender: Bool
    }
    
    private var activityIndicatorView:UIActivityIndicatorView?
    
    var messages = [Message]()
    var contactUser:ChatUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name("MessagesRead"), object: self, userInfo: ["id": contactUser?.id ?? ""])
        self.title = self.contactUser?.fullName
        self.dataSource = self
        self.delegate = self
        self.shouldScrollToBottom = true
     //   self.messageInputView.textView.delegate = self
        IQKeyboardManager.shared.enable = true
        //Add activity indicator
        self.addLoadingActivityIndicator()
    
        if contactUser?.fullName == "NAVVCAST Messages" {
            self.messageInputView.isHidden = true
            //UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber - BroadcastManager.shared.messagesCountForAppIconBadge
           // BroadcastManager.shared.messagesCountForAppIconBadge = 0
        }
        
        
        //UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber - (self.contactUser?.unreadMessages ?? 0)
        
        //Load existing messages
        self.loadExistingMessages()
        
        //Set new message notification
        self.setNewMessageNotification()
        
        //Add tap gesture recognizer for dismissing keyboard
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( tapReceived(_:)))
        self.collectionView.addGestureRecognizer(tapGestureRecognizer)
       
        self.setMessagesAsRead()
        
//        ChatManager.shared.socket?.on("users", callback: { [weak self] data, ack in
//            print(data)
//            self?.loadExistingMessages()
//
//        })
        
        var timer2 = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            self.title = self.contactUser?.fullName
        }
        
        ChatManager.shared.socket?.on("watching typing", callback: { (data, ack) in
            print("? \(data)")
            guard let data = data as? [[String: Any]] else { return }
            guard let userId = data.first?["origin"] as? String else { return }
            if self.contactUser?.id != userId { return }
            self.title = "\(self.contactUser?.fullName ?? "") ... is typing"
            
            timer2.invalidate()
            timer2 = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                self.title = self.contactUser?.fullName
            }
            
        })
        
    
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.textViewTextDidChange(_:)),
            name: UITextView.textDidChangeNotification,
            object: nil)
    }
    
    @objc func textViewTextDidChange(_ textView: UITextView) {
//        if textView.text == "" {
//                   print("? not typing")
//               } else {
//                   print("? typing")
       
       // print(self.contactUser?.id)
        ChatManager.shared.socket?.emit("typing", with: [["destiny": self.contactUser?.id ?? "", "origin": SessionManager.shared.user?.userId ?? ""]], completion: {
                      print("???")
                   })
             //  }
           
    }
   
  
    
    
    override func viewWillDisappear(_ animated: Bool) {
                IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
         self.view.setNeedsLayout()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let observedObject = object as? MSGCollectionView, observedObject == collectionView {
            if self.shouldScrollToBottom {
                self.collectionView.scrollToBottom(animated: false)
            }
            collectionView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        if let destinyId = self.contactUser?.id {
            if let message  = ChatManager.shared.sendMessage(inputView.message, destinyId: destinyId) {
                self.messages.append(message)
                let msgUser = MessageUser(displayName: ChatManager.shared.currentUser?.fullName ?? "", avatar: nil, isSender: true)
                let msgMessage = MSGMessage(id: self.messages.count, body: .text(inputView.message), user: msgUser, sentAt: message.creationDate ?? Date())
                self.insert(msgMessage)
            }
        }
    }
    
//    func loadBroadcastedMessages() {
//        guard let userId = self.contactUser?.id else { return }
//        let broadcastedMessages = BroadcastManager.shared.messages
//        var messages: [Message] = []
//        for string in broadcastedMessages {
//            let message = Message(id: "0", text: string, origin: userId, destiny: "0", status: 0, channel: "0", creationDate: Date(), seen: true)
//            messages.append(message)
//        }
//        self.messages = messages
//        self.activityIndicatorView?.stopAnimating()
//        self.collectionView.reloadData()
//    }
    
    func setMessagesAsRead() {
        if let contactUser = self.contactUser {
            ChatManager.shared.setMessagesAsRead(destiny: contactUser.id) {
                print("Completion")
            }
        }
    }
    
    func reloadMessages() {
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
        self.collectionView.reloadData()
    }
    
    @objc func tapReceived(_ sender:UITapGestureRecognizer) {
        self.messageInputView.resignFirstResponder()
        //keyboard is shown
        print("keyboard")
    }
    
    private func addLoadingActivityIndicator() {
       self.activityIndicatorView = UIActivityIndicatorView()
        self.activityIndicatorView?.style = UIActivityIndicatorView.Style.large
       self.activityIndicatorView?.hidesWhenStopped = true
       self.activityIndicatorView?.color = UIColor.gray
        self.collectionView.backgroundView = self.activityIndicatorView
       self.activityIndicatorView?.startAnimating()
   }
    
    private func loadExistingMessages() {
        if let contactUser = self.contactUser {

            ChatManager.shared.getMessages(withUser: contactUser.id) { [weak self] (messages) in
                if let messages = messages {
                    if messages.count == 0 {
                        print("zero ")
                    }
                    else if self?.contactUser?.id ==  BroadcastUser.id && messages.count > 0 && messages.first?.origin == BroadcastUser.id {
                        print("broadcast coming ")
                        self?.messages = messages
                        self?.reloadMessages()
                    } else if self?.contactUser?.id !=  BroadcastUser.id && messages.count > 0 && messages.first?.origin != BroadcastUser.id {
                        self?.messages = messages
                        self?.reloadMessages()
                    }
                }
                self?.activityIndicatorView?.stopAnimating()
            }
        }
    }
    
    private func setNewMessageNotification() {
        ChatManager.shared.didGetNewMessage = { [weak self] (message) in
            print("Got new message callback in contact: \(self?.contactUser?.id ?? "")")
            if message.destiny == ChatManager.shared.currentUser?.id &&
                message.origin == self?.contactUser?.id {
                let msgUser = MessageUser(displayName: self?.contactUser?.fullName ?? "", avatar: nil, isSender: false)
                let msgMessage = MSGMessage(id: self?.messages.count ?? 0, body: .text(message.text), user: msgUser, sentAt: message.creationDate ?? Date())
                self?.messages.append(message)
                self?.insert(msgMessage)
                return false
            }
            return true
        }
    }
    
   
}

extension MessagesViewController: MSGDataSource {
    func numberOfSections() -> Int {
        self.messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return 1
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        let message = self.messages[indexPath.section]
        
        let user:MessageUser
        
//        if self.contactUser?.fullName == "NAVVCAST Messages" {
//            user = MessageUser(displayName: self.contactUser?.fullName ?? "", avatar: nil, isSender: false)
//        } else {
         
        if message.origin == self.contactUser?.id {
            user = MessageUser(displayName: self.contactUser?.fullName ?? "", avatar: nil, isSender: false)
        }
        else {
            user = MessageUser(displayName: ChatManager.shared.currentUser?.fullName ?? "", avatar: nil, isSender: true)
        }
      //  }
        
        let msgMessage = MSGMessage(id: indexPath.section, body: .text(message.text), user: user, sentAt: message.creationDate ?? Date())
        return msgMessage
    }
    
    func footerTitle(for section: Int) -> String? {
        if let date = self.messages[section].creationDate {
            let message = self.messages[section]
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            var strDate = formatter.string(from: date)
            
            
            
            
            if contactUser?.fullName != "NAVVCAST Messages" {
                if message.origin != self.contactUser?.id {
                    //isSender == false
                    strDate += message.seen ? " ✓✓" : " ✓"

                }
            }
            return strDate
        }
        return nil
    }
    
    
    
  
}

extension MessagesViewController: MSGDelegate {
    func tapReceived(for message: MSGMessage) {
        self.messageInputView.resignFirstResponder()
    }
    
    func headerTitle(for section: Int) -> String? {
        let message = self.messages[section]
        if self.contactUser?.fullName == "NAVVCAST Messages" {
            if let isBroadcast = message.isBroadcast {
                return isBroadcast.name
            }
        } 
        
        guard let chatUser = ChatManager.shared.getUser(message.origin) else { return nil }
        return chatUser.fullName
    }
    
    func linkTapped(url: URL) {
        print("Link tapped:", url)
    }
    
    func longPressReceieved(for message: MSGMessage) {
        print("Long press:", message)
    }
    
    func shouldDisplaySafari(for url: URL) -> Bool {
        return true
    }
    
    func shouldOpen(url: URL) -> Bool {
        return true
    }
    
   
    
    
}

//extension MessagesViewController: MSGPlaceholderTextViewDelegate {
//
//    func textViewDidChange(_ textView: UITextView) {
//
//        if textView.text == "" {
//            print("? not typing")
//        } else {
//            print("? typing")
//
//            ChatManager.shared.socket?.emit("typing", with: [""], completion: {
//               print("???")
//            })
//        }
//    }
//
//}
