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
    
    @IBOutlet weak var placeholderView: UIImageView!
    @IBOutlet weak var topBarMenuView: UIView!
    @IBOutlet weak var separatorView: UIView!
    var navigatonControllerChat: UINavigationController!
    var contactsViewController: ChatContactsViewController!
    var currentMessagesVC: MessagesViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        topBarMenuView.backgroundColor = UIColor(red: 8/255, green: 76/255, blue: 132/255, alpha: 1)
        self.hideElements(hide: true)
        self.conversationContainerView.layer.cornerRadius = 20
        self.initialsCurrentUserButton.layer.cornerRadius = 10
        self.roundedBackgroundView.layer.cornerRadius = 20
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigatonControllerChat = storyboard.instantiateViewController(withIdentifier: "ContactsNavigationController") as? UINavigationController
        
        guard let contactsViewController = navigatonControllerChat?.viewControllers.first as? ChatContactsViewController else { return }
        self.contactsViewController = contactsViewController
        self.contactsViewController.didSelectContact = { [weak self] contact in
          //  print(contact)
            self?.hideElements(hide: false)
           
            self?.selectedContact = contact
            self?.currentUserNameLabel.text = self?.selectedContact?.fullName
            self?.initialsCurrentUserButton.setTitle(self?.selectedContact?.firstName?.first?.description.uppercased(), for: .normal)
            self?.goToMessages(contact)

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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setStatusBar(backgroundColor: UIColor(red: 8/255, green: 76/255, blue: 132/255, alpha: 1))
    }
    
    override func viewDidLayoutSubviews() {
       
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
               // self?.dismiss(animated: true, completion: nil)
            }
//            guard self != nil else {return}
//            SessionManager.shared.logOutTime =  "\(Date().stringFromDateZuluFormat()) succes: \(islogout) TapedButton Web Service"
//
//            if (error == nil) && islogout {
//                print("logout")
//                DispatchQueue.main.async() {
//                    self?.dismissCustomAlert()
//                    Constants.loading = false
//                    SessionManager.shared.terminateSessionLogOut()
//                }
//
//            } else {
//                self?.dismissCustomAlert()
//                //   guard self!.currentReachabilityStatus != .notReachable else {  return }
//                // Alerts.alert(with: self,for: Constants.GENERAL_ERROR_MESSAGE, with: Constants.GENERAL_ERROR_TITLE)
//                print("error in logout")
//                 Alerts.alert(with: self,for: Constants.SERVER_NOT_ANSWER, with: Constants.ERROR_TITLE)
//
//                //                Alerts.alert(with: nil,for: (response.result.error?.localizedDescription)!, with: Constants.GENERAL_ERROR_TITLE)
//
//            }
        })
        
       
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
