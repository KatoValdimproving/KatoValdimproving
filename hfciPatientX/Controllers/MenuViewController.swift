//
//  MenuViewController.swift
//  hfciPatientX
//
//  Created by user on 15/09/21.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuPresenter: RoundedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        menuPresenter.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    

    @objc func didTap() {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MapViewController") as? MapViewController {
            present(vc, animated: true, completion: nil)
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
