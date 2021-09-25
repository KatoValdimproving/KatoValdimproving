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

        
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuViewController") as? MenuViewController {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
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
        
//        LocationStreaming.sharedInstance.streamLocation()
//        LocationManager.sharedInstance.startLocationUpdates()
        
       
        SessionManager.shared.isLogedIn = true
         SessionManager.shared.sessionId = user.id
//        CoreDataManager.sharedInstance.currentSession = Session.instance(context: CoreDataManager.sharedInstance.viewContext, id: user.id)
//         CoreDataManager.sharedInstance.currentJob = Job.createAndSaveJob(context: CoreDataManager.sharedInstance.viewContext, id: JobManager.jobId ?? "n/a")
//         CoreDataManager.sharedInstance.save()
//        LocationStreaming.sharedInstance.distance = 0
        SessionManager.shared.loginTime = Date().stringFromDateZuluFormat()
        IQKeyboardManager.shared.enableAutoToolbar = false
        SessionManager.shared.user = user
     //   SessionManager.shared.expireSessionDate = Date().addingTimeInterval(TimeInterval(user.title))
     //   SessionManager.shared.startTimerToExpireSession()
     //   SocketIOManager.sharedInstance.uploadLocationAccessDenied(status: //PayloadCreator.shared.getCurrentLocationPermissionStatus())

        //Initiate beacons detection
      //  ContactTracing.shared.userId = user.userId
        
//        if let campusName = SessionManager.shared.campus?.campusIMDF.getIMDFFolderName() {
//            let levelUrl = Bundle.main.resourceURL!.appendingPathComponent("\(campusName)/level.geojson")
//            let unitUrl = Bundle.main.resourceURL!.appendingPathComponent("\(campusName)/unit.geojson")
//
//            if let levelData = try? Data(contentsOf: levelUrl),
//                let unitData = try? Data(contentsOf: unitUrl) {
//                ContactTracing.shared.initiateUnitDetection(levelData: levelData, unitData: unitData, completion: {
//                    BeaconTracingManager.shared.getBeacons(shouldMonitor: true)
//                })
//            }
//        }
//        else {
//            BeaconTracingManager.shared.getBeacons(shouldMonitor: true)
//        }
        
//        if  let _ = SessionManager.shared.campus?.campusIMDF.getIMDFFolderName()  {
//            do {
//                let imdfDecoder = IMDFDecoder()
//                guard let levelData =  try?  Data(contentsOf: imdfDecoder.getURLFor(file: .level) ?? URL(fileURLWithPath: "")) else { return }
//                guard let unitData =   try? Data(contentsOf: imdfDecoder.getURLFor(file: .unit) ?? URL(fileURLWithPath: "")) else { return }
//                ContactTracing.shared.initiateUnitDetection(levelData: levelData, unitData: unitData, completion: {
//                    BeaconTracingManager.shared.getBeacons(shouldMonitor: true)
//                })
//            }
//        } else {
//            BeaconTracingManager.shared.getBeacons(shouldMonitor: true)
//        }
        
//        self.userDefaults.set(user.userId, forKey: Constants.NAME_DRAWER_KEY)
//        if let password = self.passwordTextField.text {
//            _ = KeychainWrapper.standard.set(password, forKey: "password")
//        }
//        self.userDefaults.set(email, forKey: Constants.USE_NAME_KEY)
//
//        UserDefaults.standard.setUserID(value: user.userId)
//        print("TokenId", user.id)
//        UserDefaults.standard.setTokenId(value: user.id)
//        Constants.logged_in = true
//
//        CoreDataManager.sharedInstance.removeLogsOlderThan(days: 3)
//
//        guard let campusId = SessionManager.shared.user?.campusId else { return }
   
//        APIManager.sharedInstance.getCampus(campusId: campusId) { (campus) in
//            guard let campus = campus else { return }
//            SessionManager.shared.campus = campus
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  { return }
//            guard let campusName = SessionManager.shared.campus?.campusIMDF.getIMDFFolderName() else { return }
//            appDelegate.setUpIMDF(name: campusName)
//            TraceHealingManager.shared.start()
//            CrowdSource.shared.start()
//            FlowCoordinator.showInitialScreenTabViewController()
//        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController {
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
