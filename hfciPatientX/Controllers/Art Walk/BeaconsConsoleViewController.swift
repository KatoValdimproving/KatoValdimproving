//
//  BeaconsConsoleViewController.swift
//  hfciPatientX
//
//  Created by developer on 25/10/21.
//

import UIKit
import Mappedin





class BeaconsConsoleViewController: UIViewController  {

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var indexes = [IndexPath]()
    var didTapStop: (()->())?
    var didTapStart: (()->())?
    var selectedBeacon: Beacon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        for (index, _) in beacons.enumerated() {
            indexes.append(IndexPath(row: index, section: 0))
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification), name: Notification.Name("didRangeBeacons"), object: nil)

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "BeaconItemTableViewCell", bundle: nil), forCellReuseIdentifier: "BeaconItemTableViewCell")
        
        consoleTextView.text = consoleText
    }
    
    var consoleText = ""
    
    @objc func methodOfReceivedNotification() {
        
        for (index, beacon) in beacons.enumerated() {
            
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0) ) as? BeaconItemTableViewCell
            cell?.setInfoWith(beacon: beacon)
        }
        
        if selectedBeacon != nil {
            consoleText = consoleText + "Proximity:" + (selectedBeacon?.proximity.description)!  + "m" + "\n"
        consoleTextView.text = consoleText
        }
        
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var reload = false
    @IBAction func stopAction(_ sender: Any) {
        didTapStop?()
        reload = false
    }
    @IBAction func startAction(_ sender: Any) {
        
        didTapStart?()
        reload = true
    }
    
    


      /**
       * Called when the user click on the view (outside the UITextField).
       */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension BeaconsConsoleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let beacon = beacons[indexPath.row]
        beacon.isSelected = !beacon.isSelected
        self.selectedBeacon = beacon
        if beacon.isSelected {
            consoleText = ""
            consoleTextView.text = consoleText
            
        } else {
            self.selectedBeacon = nil
            consoleText = ""
            consoleTextView.text = consoleText
        }
        let cell = tableView.cellForRow(at: indexPath) as? BeaconItemTableViewCell
        cell?.setInfoWith(beacon: beacon)
     
    }
}

extension BeaconsConsoleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeaconItemTableViewCell", for: indexPath) as! BeaconItemTableViewCell
        let beacon = beacons[indexPath.row]
        cell.setInfoWith(beacon: beacon)
        return cell
    }
}


//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}
