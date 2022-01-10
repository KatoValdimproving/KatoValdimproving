//
//  ChatContactsViewController.swift
//  NovaTrack
//
//  Created by Juan Pablo Rodriguez Medina on 06/03/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//HFCI

import UIKit

class ChatContactsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusChat: UIBarButtonItem!
    private var activityIndicatorView:UIActivityIndicatorView?
    private var tapToRetryGestureRecognizer:UITapGestureRecognizer?
    private var errorLabel:UILabel?
    private var loadOnce = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var users:[[String]]?
    private var filteredUsers:[[String]]?
    private var recentChats = UserDefaults.standard.getRecentChats() ?? [String]()
    private var filteredRecentChat:[String]?
    private let blurView = UIView()
    private var isSearchBarEmpty:Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering:Bool {
        return self.searchController.isActive && !self.isSearchBarEmpty
    }
    
    private var isDisplayingContacts:Bool {
        return true
    }
    
    @objc func NotificationAct(_ notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let userId = userInfo["id"] as? String? {
                print(userId ?? "")
                if(userId != ""){
                    self.setUnreadMessages(userId!, 0)
                }
            }
        }
    }
    var didSelectContact: ((_ contact: ChatUser) -> Void)?
    var contactFromNotification: ChatUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blurView.frame = self.view.frame
        self.blurView.backgroundColor = .darkGray
        self.blurView.alpha = 0.5
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationAct(_:)), name: NSNotification.Name("MessagesRead"), object: nil)
        
        //Configure search controller
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
        
        //Add activity indicator
        self.addLoadingActivityIndicator()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didSocketConnect), name: Notification.Name("didSocketConnect"), object: nil)

        //New message notification
        self.setNewMessageNotification()
        
        //Notification tapped notification
        self.setNotificationTappedNotification()
        
        //Did send message callback
        self.setDidSendMessageCallback()
        
        //User status change callback
        self.setUserDidChangeStatusCallback()
        
        self.setDidNewUserConnectCallBack()
        
        BroadcastManager.shared.listen()

        self.setDidBroadcastCallback()
        
        print("🍀🦷 chat init url: \(SocketIOEnvoriment.envorimentSocketChat)")
        print("🍀🦷 chat init path:\(SocketIOEnvoriment.pathSocketChat)")
        //Preserve recent chats when the app goes inactive
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { [weak self] _ in
            UserDefaults.standard.setRecentChats(value: self?.recentChats)
            print("Will terminate: \(String(describing: self?.recentChats))")
            
        }
        
        ChatManager.shared.socket?.on(clientEvent: .connect) { [weak self] (data, ack) in

            self?.statusChat.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

            
        }
        
        ChatManager.shared.socket?.on(clientEvent: .error) {  [weak self] (data, ack) in

            self?.statusChat.tintColor = .red

        }
       
    }
    
    @objc func didSocketConnect() {
        
        self.getInitialUsers()

    }

    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("")
    }
    
    func setDidBroadcastCallback() {
    }
        
    @IBAction func displayModeDidChange(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    private func addLoadingActivityIndicator() {
        self.activityIndicatorView = UIActivityIndicatorView()
        self.activityIndicatorView?.style = UIActivityIndicatorView.Style.large
        self.activityIndicatorView?.hidesWhenStopped = true
        self.activityIndicatorView?.color = UIColor.gray
        self.tableView.backgroundView = self.activityIndicatorView
    }
    
    private func showTapToRetry(_ show:Bool, errorMessage:String? = nil) {
        
        if show {
            if self.tapToRetryGestureRecognizer == nil && self.errorLabel == nil {
                
                self.tapToRetryGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapToRetry(_:)))
                self.tableView.addGestureRecognizer(self.tapToRetryGestureRecognizer!)
                self.errorLabel = UILabel()
                self.errorLabel?.textColor = UIColor.gray
                self.errorLabel?.text = (errorMessage ?? "") + "\n\nTap To Retry"
                self.errorLabel?.textAlignment = .center
                self.errorLabel?.numberOfLines = 0
                self.tableView.addSubview(self.errorLabel!)
                self.errorLabel?.translatesAutoresizingMaskIntoConstraints = false
                self.errorLabel?.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
                self.errorLabel?.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
                self.errorLabel?.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor, constant: 30.0).isActive = true
            }
        }
        else {
            self.errorLabel?.removeFromSuperview()
            self.errorLabel = nil
            if self.tapToRetryGestureRecognizer != nil {
                self.tableView.removeGestureRecognizer(self.tapToRetryGestureRecognizer!)
                self.tapToRetryGestureRecognizer = nil
            }
        }
    }
    
    @objc func tapToRetry(_ sender:UITapGestureRecognizer) {
        self.showTapToRetry(false)
        self.getInitialUsers()
    }
    
    private func getInitialUsers() {
        
       
        
        guard let userId = SessionManager.shared.user?.userId else { return }
        self.activityIndicatorView?.startAnimating()
        ChatManager.shared.join(userId: userId) { [weak self] _ in
            
            self?.activityIndicatorView?.stopAnimating()
            if let usersDict = ChatManager.shared.usersDict {
                var usersIds = Array(usersDict.keys)
                if let ownIndex = usersIds.firstIndex(where: { $0 == userId }){
                    usersIds.remove(at: ownIndex)
                }
                
                let onlineIndex = usersIds.partition(by: { usersDict[$0]?.status == .online && usersDict[$0]?.roleName == "Admin" })
                let onlineUsers = Array(usersIds[onlineIndex...]).sorted(by: { usersDict[$0]?.lastName?.lowercased() ?? "" < usersDict[$1]?.lastName?.lowercased() ?? "" })
                let broadcastUser = [BroadcastUser.id]
                self?.users = [broadcastUser , onlineUsers]
                
                self?.tableView.reloadData()
                
                
                if let contact = self?.contactFromNotification {
                    print("contact")
                }
            }
//            else
        }
    }
    
    private func setNewMessageNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(ChatManager.Notifications.newMessage), object: nil, queue: .main) { [weak self] notification in
            
            if let message = notification.userInfo?["message"] as? Message {
                print("Got new message: \(message)")
                if self?.navigationController?.viewControllers.count == 1,
                    let contact = ChatManager.shared.getUser(message.origin) {
                    self?.setUnreadMessages(contact.id, contact.unreadMessages + 1)
                }
                self?.setAsRecent(message.origin)
            }
        }
    }
    
    private func setNotificationTappedNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ChatManager.Notifications.notificationTapped), object: nil, queue: .main) { [weak self] (notification) in
            if let originId = notification.userInfo?["originId"] as? String,
                let contactUser = ChatManager.shared.getUser(originId) {
                self?.navigationController?.popToRootViewController(animated: false)
                self?.goToMessages(contactUser, animated: false)
            }
        }
    }
    
    private func setAsRecent(_ userId:String) {
       if let userIndex = self.recentChats.firstIndex(of: userId) {
           self.recentChats.remove(at: userIndex)
       }
       self.recentChats.insert(userId, at: 0)
    }
    
    private func setUnreadMessages(_ userId:String, _ count:Int) {
        ChatManager.shared.usersDict?[userId]?.setUnread(count)
        if !self.isFiltering {
            var indexPath:IndexPath?
            if self.isDisplayingContacts {
                indexPath = self.getUserIndex(userId)
            }
            else if let index = self.recentChats.firstIndex(of: userId) {
                indexPath = IndexPath(row: index, section: 0)
            }
            if indexPath != nil {
                self.tableView.reloadRows(at: [indexPath!], with: .none)
            }
        }
    }
    
    private func setDidSendMessageCallback() {
        ChatManager.shared.didSendMessage = { [weak self] (message) in
            if let destinyIndex = self?.recentChats.firstIndex(of: message.destiny) {
                self?.recentChats.remove(at: destinyIndex)
            }
            self?.recentChats.insert(message.destiny, at: 0)
        }
    }
    
    private func setDidNewUserConnectCallBack() {
        ChatManager.shared.didNewUserConnect = { [weak self] (user) in
            ChatManager.shared.emitToReloadUser()
        }
    }
    
    private func getSectionForStatus(_ status:ChatUser.Status) -> Int {
        switch status {
            case .broadcast: return 0
            case .online: return 1
            default: return 1
        }
    }
    
    private func getColorForStatus(_ status:ChatUser.Status) -> UIColor? {
        switch status {
        case .broadcast:
            return .clear
        case .online:
            return UIColor(hex: "#3DA64EFF")
        default:
            return .clear
        }
    }
    
    private func setUserDidChangeStatusCallback() {
        ChatManager.shared.userDidChangeStatus = { [weak self] (oldStatusUser, newStatusUser) in
            
            ChatManager.shared.emitToReloadUser()
        }
    }
    
    private func goToMessages(_ contact:ChatUser, animated:Bool) {
        //self.setUnreadMessages(contact.id, 0)
        let messagesVC = MessagesViewController()
        messagesVC.contactUser = contact
        if contact.id == BroadcastUser.id {
            BroadcastManager.shared.messagesCountForAppIconBadge = 0
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(messagesVC, animated: animated)
    }
    
    func goToBroadCastMessages(animated:Bool) {
        //self.setUnreadMessages(contact.id, 0)
        guard let broadcastUserIndex = self.getUserIndex(BroadcastUser.id) else { return }
        guard let broadcastUser = self.getUser(broadcastUserIndex) else { return }
        BroadcastManager.shared.messagesCountForAppIconBadge = 0
        let messagesVC = MessagesViewController()
        messagesVC.contactUser = broadcastUser
        self.tableView.reloadData()
        self.navigationController?.pushViewController(messagesVC, animated: animated)
        
        
    }
    
    private func filterContactsForSearchText(_ contacts:[String], _ searchText:String) -> [String] {
        
        return contacts.filter({ userId in
            let user = ChatManager.shared.getUser(userId)
            return (user?.firstName?.starts(with: searchText) ?? false) ||
                (user?.lastName?.lowercased().starts(with: searchText.lowercased()) ?? false)
        })
    }
    
    private func getUserIndex(_ userId:String) -> IndexPath? {
        if let broadcastIndex = self.users?[0].firstIndex(where: { $0 == userId }) {
            return IndexPath(row: broadcastIndex, section: 0)
        }
        else  if let onlineIndex = self.users?[1].firstIndex(where: { $0 == userId }) {
            return IndexPath(row: onlineIndex, section: 1)
        }
        
        return nil
    }
    
    private func getUser(_ index:IndexPath) -> ChatUser? {
        if let id = self.users?[index.section][index.row] {
            return ChatManager.shared.usersDict?[id]
        }
        return nil
    }
    
    private func getFilteredUser(_ index:IndexPath) -> ChatUser? {
        if let id = self.filteredUsers?[index.section][index.row] {
            return ChatManager.shared.usersDict?[id]
        }
        return nil
    }
    
    private func getRecentUser(_ index:Int) -> ChatUser? {
        let id = self.recentChats[index]
        return ChatManager.shared.getUser(id)
    }
    
    private func getFilteredRecentUser(_ index:Int) -> ChatUser? {
        if let id = self.filteredRecentChat?[index] {
            return ChatManager.shared.getUser(id)
        }
        return nil
    }
}

extension ChatContactsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isDisplayingContacts ? self.users?.count ?? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isDisplayingContacts {
            return self.isFiltering ? self.filteredUsers?[section].count ?? 0 : self.users?[section].count ?? 0
        }
        else {
            return self.isFiltering ? self.filteredRecentChat?.count ?? 0 : self.recentChats.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var contact:ChatUser?
        
        if self.isDisplayingContacts {
            contact = self.isFiltering ? self.getFilteredUser(indexPath) : self.getUser(indexPath)
        }
        else {
            contact = self.isFiltering ? self.getFilteredRecentUser(indexPath.row) : self.getRecentUser(indexPath.row)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTVCell
        
        if contact?.id == BroadcastUser.id {
            cell.statusIndicatorView.isHidden = true
            cell.contentView.backgroundColor = UIColor(hex: "#EBEBEB")
            cell.accessoryType = .none
            cell.setUnreadCount(BroadcastManager.shared.messagesCountForAppIconBadge)

        }  else {
            cell.statusIndicatorView.isHidden = false
            cell.contentView.backgroundColor = .white
            cell.accessoryType = .disclosureIndicator
            cell.setUnreadCount(contact?.unreadMessages ?? 0)
        }
        
        cell.contactNameLabel.text = contact?.fullName
        cell.initialsButton.setTitle(contact?.initials, for: .normal)
        cell.statusIndicatorView.backgroundColor = self.getColorForStatus(contact?.status ?? .unknown)
        
        cell.didTapInitialsButton = { [weak self] sender in
        }
        if let contact = contact, contact.unreadMessages > 0 {
            self.setAsRecent(contact.id)
        }
        
        return cell
    }
}

extension ChatContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isDisplayingContacts {
            if self.isFiltering {
                if let contact = self.getFilteredUser(indexPath) {
                    self.didSelectContact?(contact)
                  //  self.goToMessages(contact, animated: true)
                }
            } else {
                if let contact = self.getUser(indexPath) {
                    //self.goToMessages(contact, animated: true)
                    self.didSelectContact?(contact)

                }
            }
            
        } else  {
            if self.isFiltering {
                if let contact = self.getFilteredRecentUser(indexPath.row) {
                    //self.goToMessages(contact, animated: true)
                    self.didSelectContact?(contact)

                }
                
            } else {
                if let contact = self.getRecentUser(indexPath.row) {
                   // self.goToMessages(contact, animated: true)
                    self.didSelectContact?(contact)

                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.isDisplayingContacts {
            let showBroadcast = self.isFiltering ? (self.filteredUsers?[0].count ?? 0) > 0 : (self.users?[0].count ?? 0) > 0
            let showOnline = self.isFiltering ? (self.filteredUsers?[1].count ?? 0) > 0 : (self.users?[1].count ?? 0) > 0
            
            switch section {
            case 0:
                return showBroadcast ? "NAVVCAST" : nil
            case 1:
                return showOnline ? "ONLINE" : nil
            case 2:
                return nil
            default:
                return nil
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
  
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        var chatUser: ChatUser = ChatUser(id: "", channel: "", fullName: "", firstName: "", lastName: "", initials: "", roleName: "", status: .inactive, unreadMessages: 0)
        
        if self.isDisplayingContacts {
            if self.isFiltering {
                if let contact = self.getFilteredUser(indexPath) {
                    chatUser = contact
                }
            } else {
                if let contact = self.getUser(indexPath) {
                    chatUser = contact
                }
            }
            
        } else  {
            if self.isFiltering {
                if let contact = self.getFilteredRecentUser(indexPath.row) {
                    chatUser = contact
                }
                
            } else {
                if let contact = self.getRecentUser(indexPath.row) {
                    chatUser = contact
                }
            }
        }
        
        let call = UIContextualAction(style: .normal, title: "Call") {  (action, view, closure) in
            
            if chatUser.phoneNumber != nil {
              //  makeAPhoneCall(number: String(phoneNumber))
            } else {
                Alerts.displayAlert(with: "Hey", and: "No phone number registered for this user")
            }
        }
        call.image = UIImage(named: "call")
        call.backgroundColor = UIColor(red: 40/255, green: 67/255, blue: 163/255, alpha: 1)
        return UISwipeActionsConfiguration(actions: [])

    }
}

extension ChatContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if let broadcast = self.users?[0], let online = self.users?[1] {
                let onlineFiltered = self.filterContactsForSearchText(online, searchText)
                let broadcastFiltered = self.filterContactsForSearchText(broadcast, searchText)
                self.filteredUsers = [broadcastFiltered, onlineFiltered]
                self.tableView.reloadData()
            }
        }
    }
}
