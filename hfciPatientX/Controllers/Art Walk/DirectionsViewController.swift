//
//  DirectionsViewController.swift
//  hfciPatientX
//
//  Created by developer on 18/10/21.
//

import UIKit
import DropDown

class DirectionsViewController: UIViewController {

    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    let menu : DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Visit",
            "Consult", "3", "4", "5", "6"
        ]
        return menu
    }()
    
    
    let menuTwo : DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Visit",
            "Consult", "3", "4", "5", "6"
        ]
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.backButton.layer.cornerRadius = 10
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapFrom))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        fromView.addGestureRecognizer(gesture)
        
        let gestureTwo = UITapGestureRecognizer(target: self, action: #selector(didTapFrom))
        gestureTwo.numberOfTapsRequired = 1
        gestureTwo.numberOfTouchesRequired = 1
        toView.addGestureRecognizer(gestureTwo)
        
        menu.anchorView = fromView
        menuTwo.anchorView = toView


    }
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.flowLayout.invalidateLayout()
       // navigateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    @objc func didTapFrom() {
        menu.show()
    }
    
    @objc func didTapTo() {
        menu.show()
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
