//
//  LoginViewController.swift
//  hfciPatientX
//
//  Created by user on 15/09/21.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift
import MaterialComponents

class LoginViewController: UIViewController {

    @IBOutlet weak var helpLbl: UIImageView!
    @IBOutlet weak var NameTxtImp: UITextField!
    @IBOutlet weak var dropDown: UIView!
    @IBOutlet weak var roleLBL: UILabel!
    @IBOutlet weak var enterButton: MDCButton!
    @IBOutlet weak var deviceIdLBL: UILabel!
    
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBAction func sendInfo(_ sender: Any) {
        logIn()
    }
    
    let menu : DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Visit",
            "Consult"
        ]
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logOut()
        enterButton.layer.cornerRadius = 7
        menu.anchorView = dropDown
        menu.selectionAction = { index, title in
            self.roleLBL.text = title
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        dropDown.addGestureRecognizer(gesture)
        
        let helpGesture = UITapGestureRecognizer(target: self, action: #selector(didRequestHelp))
        helpGesture.numberOfTapsRequired = 1
        helpGesture.numberOfTouchesRequired = 1
        helpLbl.isUserInteractionEnabled = true
        helpLbl.addGestureRecognizer(helpGesture)
        
        deviceIdLBL.text = SettingsBundleHelper.shared.testerId
        self.appVersionLabel.text = appVersion() + " " + appBuild()
    }

    @objc func didTap() {
        menu.show()
    }
    
    @objc func didRequestHelp() {
        if(NameTxtImp.hasText){
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
                self.navigationController?.pushViewController(vc, animated: true)
                vc.showChat = true
            }
        }else{
            NameTxtImp.layer.borderColor = UIColor.red.cgColor
            NameTxtImp.layer.borderWidth = 1.0
        }
    }
    
    func logOut() {
        APIManager.sharedInstance.logOut(completionHandler: {  islogout,error in
            if islogout {
              //  self?.navigationController?.popToRootViewController(animated: true)
               // self?.dismiss(animated: true, completion: nil)
            }
        })
    }

    func logIn() {
        guard let name = self.NameTxtImp.text, self.NameTxtImp.hasText else { return }
        self.NameTxtImp.text = ""
        SessionManager.shared.userName = name

        
        let testUser =  SettingsBundleHelper.shared.testerId + "@hfhs.org"
        APIManager.sharedInstance.login(viewController: self, password: "Henryford1!", email: testUser,  completionHandler: { [weak self] loginResponseObject, jobId, error in
            if Constants.loading {
                self?.dismissCustomAlert()
                Constants.loading = false
            }
            guard self != nil else { self?.dismissCustomAlert(); return }
            
            if loginResponseObject == nil && self != nil {
              //  self!.loginError()
                print("error login \(String(describing: error?.localizedDescription))")
            } else {
                self?.processLogin(user: loginResponseObject!, email: testUser, jobId: jobId)
            }
        })
    }
   

    
    func processLogin(user: User, email:String, jobId: String?) {
        
        SocketIOManager.sharedInstance.establishConnection()
        JobManager.jobId = jobId
        print("🍀 🎗 JobManager.jobId \(String(describing: JobManager.jobId))")
        
       
        SessionManager.shared.isLogedIn = true
         SessionManager.shared.sessionId = user.id
        SessionManager.shared.loginTime = Date().stringFromDateZuluFormat()
        IQKeyboardManager.shared.enableAutoToolbar = false
        SessionManager.shared.user = user
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
                self.navigationController?.pushViewController(menuViewController, animated: true)
        }
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
