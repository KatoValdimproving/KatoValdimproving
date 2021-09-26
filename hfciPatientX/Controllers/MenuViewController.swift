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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        menuPresenter.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
        
        let helpGesture = UITapGestureRecognizer(target: self, action: #selector(didRequestHelp))
        helpGesture.numberOfTapsRequired = 1
        helpGesture.numberOfTouchesRequired = 1
        helpLbl.isUserInteractionEnabled = true
        helpLbl.addGestureRecognizer(helpGesture)
    }
    

    @objc func didTap() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MapViewController") as? MapViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func didRequestHelp() {
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
