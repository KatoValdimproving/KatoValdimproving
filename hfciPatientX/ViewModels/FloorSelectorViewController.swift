//
//  FloorSelectorViewController.swift
//  hfciPatientX
//
//  Created by user on 21/12/21.
//

import UIKit

class FloorSelectorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        // Do any additional setup after loading the view.
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
