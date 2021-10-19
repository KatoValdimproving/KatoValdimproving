//
//  HomeViewController.swift
//  hfciPatientX
//
//  Created by developer on 06/10/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logout: UIImageView!
    var chatViewController: UIViewController!
   // var menuViewController: UIViewController!
    var mapViewController: UIViewController!
    var showChat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard  let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else { return }
        self.chatViewController = chatViewController
       // self.chatViewController.willMove(toParent: self)
        self.chatViewController.view.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        
//        guard  let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
//        self.menuViewController = menuViewController
//       // self.chatViewController.willMove(toParent: self)
//        self.menuViewController.view.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        
        guard  let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        self.mapViewController = mapViewController
       // self.chatViewController.willMove(toParent: self)
        self.mapViewController.view.frame = CGRect(x: 0, y: 0, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
        
        
        
       // containerView.addSubview(self.menuViewController.view)
        containerView.addSubview(self.chatViewController.view)
        containerView.addSubview(self.mapViewController.view)

        
      //  self.addChild(self.chatViewController)
      //  self.chatViewController.didMove(toParent: self)
        if showChat {
            self.chatAction(self)
        }
        
        let exitGesture = UITapGestureRecognizer(target: self, action: #selector(didExit))
        exitGesture.numberOfTapsRequired = 1
        exitGesture.numberOfTouchesRequired = 1
        logout.isUserInteractionEnabled = true
        logout.addGestureRecognizer(exitGesture)
        
    }
    

    
    @IBAction func menuAction(_ sender: Any) {
       // self.containerView.bringSubviewToFront(self.menuViewController.view)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func wayFindingAction(_ sender: Any) {
        self.containerView.bringSubviewToFront(self.mapViewController.view)

    }
    
     @IBAction func chatAction(_ sender: Any) {
         self.containerView.bringSubviewToFront(self.chatViewController.view)

     }
    
    @objc func didExit() {
        APIManager.sharedInstance.logOut(completionHandler: { [weak self] islogout,error in
            if islogout {
                self?.navigationController?.popToRootViewController(animated: true)
               // self?.dismiss(animated: true, completion: nil)
            }
        })
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
