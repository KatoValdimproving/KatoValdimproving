//
//  LoginViewController.swift
//  hfciPatientX
//
//  Created by user on 15/09/21.
//

import UIKit
import DropDown

class LoginViewController: UIViewController {

    @IBOutlet weak var NameTxtImp: UITextField!
    @IBOutlet weak var dropDown: UIView!
    @IBOutlet weak var roleLBL: UILabel!
    @IBAction func sendInfo(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuViewController") as? MenuViewController {
            present(vc, animated: true, completion: nil)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
