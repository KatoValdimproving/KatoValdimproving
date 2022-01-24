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
    var menu : DropDown!
    
    
    var menuTwo : DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.backButton.layer.cornerRadius = 10
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(backAction), name: Notification.Name("endGuidedTour"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backAction), name: Notification.Name("endGuidedTour"), object: nil)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapFrom))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        fromView.addGestureRecognizer(gesture)
        
        menu.selectionAction = { index, title in
            self.fromLabel.text = title
            self.mapViewcontroller!.point1 = title == "Your Location" ? nil : self.mapViewcontroller?.nodeLocations.filter{$0.name == title}.first
            if(self.mapViewcontroller!.point2 != nil){
                self.mapViewcontroller!.getDirection()
            }
        }
        
        let gestureTwo = UITapGestureRecognizer(target: self, action: #selector(didTapTo))
        gestureTwo.numberOfTapsRequired = 1
        gestureTwo.numberOfTouchesRequired = 1
        toView.addGestureRecognizer(gestureTwo)
        
        menuTwo.selectionAction = { index, title in
            self.toLabel.text = title
            self.mapViewcontroller!.point2 = self.mapViewcontroller!.nodeLocations.filter{$0.name == title}.first
            self.mapViewcontroller!.getDirection()
        }
        
        menu.anchorView = fromView
        menuTwo.anchorView = toView
        

        tableView.delegate = self
        tableView.dataSource = self
        let cell2 = UINib(nibName: "DirectionsTableViewCell", bundle: nil)
        self.tableView.register(cell2, forCellReuseIdentifier: "DirectionsTableViewCell")
        self.mapViewcontroller?.showGoToArtwalkButton(isHidden: true)
        
        self.fromLabel.text = "Your Location"
        self.toLabel.text = self.painting?.location
        self.mapViewcontroller?.point2 = self.mapViewcontroller?.getLocationWithPainting(painting: self.painting!)
        
        menu.dataSource = []
        menuTwo.dataSource = []
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
        //menu.show()
    }
    
    @objc func didTapTo() {
        //menuTwo.show()
    }

    @IBAction func backAction(_ sender: Any) {
        mapViewcontroller?.goBack(self)
        mapViewcontroller?.stopScanning(painting: self.painting)
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
