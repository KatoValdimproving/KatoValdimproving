//
//  MenuViewController.swift
//  hfciPatientX
//
//  Created by user on 15/09/21.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var helpLbl: UIImageView!
    @IBOutlet weak var menuPresenter: RoundedView!
    @IBOutlet weak var visitorsNameLabel: UILabel!
    @IBOutlet weak var deviceIdLBL: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var saluteLBL: UILabel!
    @IBOutlet weak var artWBtn: RoundedView!
    
    let salutes = [
        "Hi!",
        "Greetings!",
        "Hello!",
        "Good day!"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.visitorsNameLabel.text = SessionManager.shared.userName
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        menuPresenter.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
        let gestureAW = UITapGestureRecognizer(target: self, action: #selector(didTapAW))
        gestureAW.numberOfTapsRequired = 1
        gestureAW.numberOfTouchesRequired = 1
        artWBtn.addGestureRecognizer(gestureAW)
        
        
        let helpGesture = UITapGestureRecognizer(target: self, action: #selector(didRequestHelp))
        helpGesture.numberOfTapsRequired = 1
        helpGesture.numberOfTouchesRequired = 1
        helpLbl.isUserInteractionEnabled = true
        helpLbl.addGestureRecognizer(helpGesture)
        
        deviceIdLBL.text = SettingsBundleHelper.shared.testerId
        self.appVersionLabel.text = appVersion() + " " + appBuild()
        
        saluteLBL.text = salutes[Int.random(in: 0..<salutes.count)]
        
    }
    

    @objc func didTap() {
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MapViewController") as? MapViewController {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func didTapAW() {
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MapViewController") as? MapViewController {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(vc, animated: true)
            vc.showArtWalk = true
        }
        
    }
    
    @objc func didRequestHelp() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(vc, animated: true)
            vc.showChat = true
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
