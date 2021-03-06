//
//  ChatViewController.swift
//  hfciPatientX
//
//  Created by developer on 22/09/21.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var contactsContainerView: UIView!
    @IBOutlet weak var conversationContainerView: UIView!
    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var initialsCurrentUserButton: UIButton!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    var selectedContact: ChatUser?
    
    @IBOutlet weak var placeholderView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    var navigatonControllerChat: UINavigationController!
    var contactsViewController: ChatContactsViewController!
    var currentMessagesVC: MessagesViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideElements(hide: true)
        self.conversationContainerView.layer.cornerRadius = 20
        self.initialsCurrentUserButton.layer.cornerRadius = 10
        self.roundedBackgroundView.layer.cornerRadius = 20
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigatonControllerChat = storyboard.instantiateViewController(withIdentifier: "ContactsNavigationController") as? UINavigationController
        
        guard let contactsViewController = navigatonControllerChat?.viewControllers.first as? ChatContactsViewController else { return }
      
        self.contactsViewController = contactsViewController
       
        self.contactsViewController.didSelectContact = { [weak self] contact in
            print(contact)
//            self?.hideElements(hide: false)
//
//            self?.selectedContact = contact
//            self?.currentUserNameLabel.text = self?.selectedContact?.fullName
//            self?.initialsCurrentUserButton.setTitle(self?.selectedContact?.firstName?.first?.description.uppercased(), for: .normal)
            self?.goToMessages(contact)

        }
      
      
        
      //  self.view.layoutIfNeeded()
        self.contactsViewController.contactFromNotification = self.selectedContact

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.setStatusBar(backgroundColor: UIColor(red: 8/255, green: 76/255, blue: 132/255, alpha: 1))
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let user = self.selectedContact {
//            self.contactsViewController.didSelectContact?(user)
//            
//        }
    }
    
    override func viewDidLayoutSubviews() {
        self.navigatonControllerChat.willMove(toParent: self)

        self.navigatonControllerChat.view.frame = CGRect(x: 0, y: 0, width: self.contactsContainerView.bounds.width, height: self.contactsContainerView.bounds.height)
        contactsContainerView.addSubview(navigatonControllerChat.view)

        self.addChild(self.navigatonControllerChat)
        self.navigatonControllerChat.didMove(toParent: self)
//        self.contactsViewController.view.layoutSubviews()
//        self.contactsViewController.view.layoutIfNeeded()
    }
    
    func hideElements(hide: Bool) {
        self.currentUserNameLabel.isHidden = hide
        self.initialsCurrentUserButton.isHidden = hide
        self.separatorView.isHidden = hide
        self.placeholderView.isHidden = !hide
    }
    
    @objc func didExit() {
        
        APIManager.sharedInstance.logOut(completionHandler: { [weak self] islogout,error in
            
            if islogout {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        })
        
       
    }
    
    @IBAction func exitToMap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitToMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func addConversationViewToContainer(_ contact:ChatUser) {
        self.currentMessagesVC = MessagesViewController()
        currentMessagesVC!.contactUser = contact
        currentMessagesVC!.view.frame = CGRect(x: 0, y: 0, width: self.conversationContainerView.bounds.width, height: self.conversationContainerView.bounds.height)

        currentMessagesVC!.willMove(toParent: self)

        conversationContainerView.addSubview(currentMessagesVC!.view)
        self.addChild(currentMessagesVC!)
            self.currentMessagesVC!.didMove(toParent: self)
    }
    

     func goToMessages(_ contact:ChatUser) {
        //self.setUnreadMessages(contact.id, 0)
        
        // Notify Child View Controller
        
         self.hideElements(hide: false)
         self.selectedContact = contact
         self.currentUserNameLabel.text = self.selectedContact?.fullName
         self.initialsCurrentUserButton.setTitle(self.selectedContact?.firstName?.first?.description.uppercased(), for: .normal)
         
        if  self.currentMessagesVC == nil  {
       
            addConversationViewToContainer(contact)
            
        } else {
        

            self.currentMessagesVC!.willMove(toParent: nil)
            self.currentMessagesVC!.view.removeFromSuperview()
            self.currentMessagesVC?.removeFromParent()
            addConversationViewToContainer(contact)

        }
        
//        if contact.id == BroadcastUser.id {
//            BroadcastManager.shared.messagesCountForAppIconBadge = 0
//           // self.tableView.reloadData()
//        }
       // self.navigationController?.pushViewController(messagesVC, animated: animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
