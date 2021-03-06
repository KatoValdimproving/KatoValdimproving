//
//  HomeViewController.swift
//  hfciPatientX
//
//  Created by developer on 06/10/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var artWalkButton: UIButton!
    @IBOutlet weak var wayfindingBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var containerView: UIView!

    var chatViewController: ChatViewController!
    var mapViewController: MapViewController!
   weak var beaconsConsoleViewController: BeaconsConsoleViewController?
    var showChat = false
    var showArtWalk = false
    var chatUser: ChatUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wayfindingBtn.titleLabel?.font = .boldSystemFont(ofSize: 23)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard  let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else { return }
        self.chatViewController = chatViewController
        self.chatViewController.view.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        artWalkButton.isEnabled = false
        
        guard  let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        self.mapViewController = mapViewController
        self.mapViewController.didRangedBeacons = {
            if self.beaconsConsoleViewController != nil {
                self.beaconsConsoleViewController?.methodOfReceivedNotification()
            }
        }
        self.mapViewController.didFinishLoadingMap = {
            self.artWalkButton.isEnabled = true
            if(self.showArtWalk){
                self.artWalkAction(self)
            }
        }
        self.mapViewController.view.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        
        containerView.addSubview(self.chatViewController.view)
        containerView.addSubview(self.mapViewController.view)

        if showChat {
            self.chatAction(self)
        }
        
        self.mapViewController.artWalkContainerView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NewChatMessage"), object: nil)

        if let chatUser = self.chatUser {
            self.containerView.bringSubviewToFront(self.chatViewController.view)
            self.chatViewController.selectedContact = chatUser
        }
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let chatUser = userInfo["Message"] as? ChatUser {
              //  print(userId)
                self.containerView.bringSubviewToFront(self.chatViewController.view)
                self.chatViewController.goToMessages(chatUser)
            }
        }
    }

    

    @IBAction func artWalkAction(_ sender: Any) {
        SessionManager.shared.isArtWalkModeSelected = true
      //  self.mapViewController.startScanning()
        self.containerView.bringSubviewToFront(self.mapViewController.view)
        self.mapViewController.view.bringSubviewToFront(self.mapViewController.artWalkContainerView)
        self.mapViewController.controlls.isHidden = true
        self.mapViewController.artWalkContainerView.isHidden = false
        self.showArtWalk = true
        self.mapViewController.goBack(self)
        self.artWalkButton.titleLabel?.font = .boldSystemFont(ofSize: 23)
        self.wayfindingBtn.titleLabel?.font = .systemFont(ofSize: 23)
        self.chatButton.titleLabel?.font = .systemFont(ofSize: 23)
    }
    
    func logOut() {
        APIManager.sharedInstance.logOut(completionHandler: {  islogout,error in
            if islogout {
              //  self?.navigationController?.popToRootViewController(animated: true)
               // self?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func wayFindingAction(_ sender: Any) {
        self.containerView.bringSubviewToFront(self.mapViewController.view)
        self.mapViewController.goBack(self)
        self.mapViewController.controlls.isHidden = false
        self.mapViewController.artWalkContainerView.isHidden = true
        self.mapViewController.showGoToArtwalkButton(isHidden: true)
        self.showArtWalk = false
        self.mapViewController.goBack(self)
        self.wayfindingBtn.titleLabel?.font = .boldSystemFont(ofSize: 23)
        self.artWalkButton.titleLabel?.font = .systemFont(ofSize: 23)
        self.chatButton.titleLabel?.font = .systemFont(ofSize: 23)
    }
    
     @IBAction func chatAction(_ sender: Any) {
         self.containerView.bringSubviewToFront(self.chatViewController.view)
         self.wayfindingBtn.titleLabel?.font = .systemFont(ofSize: 23)
         self.artWalkButton.titleLabel?.font = .systemFont(ofSize: 23)
         self.chatButton.titleLabel?.font = .boldSystemFont(ofSize: 23)
     }
    
    @IBAction func consoleAction(_ sender: Any) {
        
        showBeaconConsole()
      // showPopUpPainting()
        
    }
    func showPopUpPainting() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let paintingBeaconViewController = storyboard.instantiateViewController(withIdentifier: "PaintingBeaconViewController") as? PaintingBeaconViewController {
        
          //  paintingBeaconViewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
            paintingBeaconViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            paintingBeaconViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(paintingBeaconViewController, animated: true, completion: nil)
            
        }
    }
    func showBeaconConsole() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let console = storyboard.instantiateViewController(withIdentifier: "BeaconsConsoleViewController") as? BeaconsConsoleViewController {
            self.beaconsConsoleViewController = console
            console.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            console.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            console.didTapStop = {
               self.mapViewController.stopScanning(painting: nil)

            }
            
            console.didTapStart = {
               self.mapViewController.startScanningPainting(painting: nil)
            }
        self.navigationController?.present(console, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        APIManager.sharedInstance.logOut(completionHandler: { [weak self] islogout,error in
            if islogout {
                self?.navigationController?.popToRootViewController(animated: true)
               // self?.dismiss(animated: true, completion: nil)
                
            }
        })
    }
    @objc func didExit() {
        
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
