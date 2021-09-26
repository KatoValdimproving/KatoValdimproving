//
//  LoginViewController.swift
//  hfciPatientX
//
//  Created by user on 15/09/21.
//

import UIKit
import DropDown
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var NameTxtImp: UITextField!
    @IBOutlet weak var dropDown: UIView!
    @IBOutlet weak var roleLBL: UILabel!
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
        
        menu.anchorView = dropDown
        menu.selectionAction = { index, title in
            self.roleLBL.text = title
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        dropDown.addGestureRecognizer(gesture)
    }

    @objc func didTap() {
        menu.show()
    }

    func logIn() {
        let testUser = "test" + SettingsBundleHelper.shared.testerId
        APIManager.sharedInstance.login(viewController: self, password: "12345", email: "jose.valdez",  completionHandler: { [weak self] loginResponseObject, jobId, error in
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
            if let chatViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController {
                self.navigationController?.pushViewController(chatViewController, animated: true)
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
