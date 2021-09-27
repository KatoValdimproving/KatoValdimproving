//
//  ChatViewController.swift
//  hfciPatientX
//
//  Created by developer on 22/09/21.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var exitLbl: UIImageView!
    @IBOutlet weak var contactsContainerView: UIView!
    @IBOutlet weak var conversationContainerView: UIView!
    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var initialsCurrentUserButton: UIButton!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    var selectedContact: ChatUser?
    
    @IBOutlet weak var separatorView: UIView!
    var navigatonControllerChat: UINavigationController!
    var contactsViewController: ChatContactsViewController!
    var currentMessagesVC: MessagesViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentUserNameLabel.text = SessionManager.shared.userName
        self.initialsCurrentUserButton.setTitle(SessionManager.shared.userName?.first?.description.uppercased(), for: .normal)
        self.conversationContainerView.layer.cornerRadius = 20
        self.initialsCurrentUserButton.layer.cornerRadius = 10
        self.roundedBackgroundView.layer.cornerRadius = 20
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigatonControllerChat = storyboard.instantiateViewController(withIdentifier: "ContactsNavigationController") as? UINavigationController
        
        guard let contactsViewController = navigatonControllerChat?.viewControllers.first as? ChatContactsViewController else { return }
        self.contactsViewController = contactsViewController
        self.contactsViewController.didSelectContact = { contact in
          //  print(contact)
            self.selectedContact = contact
            self.goToMessages(contact)

        }
        self.navigatonControllerChat.willMove(toParent: self)

        self.navigatonControllerChat.view.frame = CGRect(x: 0, y: 0, width: self.contactsContainerView.bounds.width, height: self.contactsContainerView.bounds.height)
        contactsContainerView.addSubview(navigatonControllerChat.view)
        self.addChild(self.navigatonControllerChat)
        self.navigatonControllerChat.didMove(toParent: self)
        
        let exitGesture = UITapGestureRecognizer(target: self, action: #selector(didExit))
        exitGesture.numberOfTapsRequired = 1
        exitGesture.numberOfTouchesRequired = 1
        exitLbl.isUserInteractionEnabled = true
        exitLbl.addGestureRecognizer(exitGesture)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
       
    }
    
    @objc func didExit() {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
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
    

    private func goToMessages(_ contact:ChatUser) {
        //self.setUnreadMessages(contact.id, 0)
        
        // Notify Child View Controller
        
        
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
