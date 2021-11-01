//
//  DirectionsViewController.swift
//  hfciPatientX
//
//  Created by developer on 18/10/21.
//

import UIKit
import DropDown

class DirectionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    var directionsString: [String] = []
    var mapViewcontroller: MapViewController?
    var painting: Painting?
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
        
        
        
        print(self.directionsString)

        tableView.delegate = self
        tableView.dataSource = self
        let cell2 = UINib(nibName: "DirectionsTableViewCell", bundle: nil)
        self.tableView.register(cell2, forCellReuseIdentifier: "DirectionsTableViewCell")
        self.mapViewcontroller?.showGoToArtwalkButton(isHidden: true)
        
        self.fromLabel.text = "Your Location"
        self.toLabel.text = self.painting?.location
    }
    
    
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.flowLayout.invalidateLayout()
       // navigateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.reloadData()
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

extension DirectionsViewController : UITableViewDelegate {
}

extension DirectionsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.directionsString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionsTableViewCell") as? DirectionsTableViewCell {
                let data = self.directionsString[indexPath.row]
                cell.directionImage.image = imageForDirection(option: data)
                cell.directionLBL.text = data
                return cell
            }
        
            
        return UITableViewCell()
    }
}
