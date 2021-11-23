//
//  BeaconItemTableViewCell.swift
//  hfciPatientX
//
//  Created by developer on 25/10/21.
//

import UIKit

class CustomTextView: UITextField {
    var canResign:Bool = false
    override var canResignFirstResponder: Bool{
        return canResign
    }
}

//// this is when to use
//@objc func keyboardWillShow(_ notification: Notification) {
//            self.textViewComment.canResign = false
//}

//override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        // make keyboard hide
//        self.textViewComment.canResign = true
//}

class BeaconItemTableViewCell: UITableViewCell  {

    @IBOutlet weak var rrsiLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var mayorLabel: UILabel!
    @IBOutlet weak var proximityLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var clproximityLabel: UILabel!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var checkView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var beacon: Beacon?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.checkView.isHidden = true

    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfoWith(beacon: Beacon) {
        print("❤️ \(beacon.minor) \(beacon.mayor)")
        self.beacon = beacon
        identifierLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Identifier", sizeTop: 13, secondLine: beacon.identifier, sizeBottom: 13, color: .black)
        mayorLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Mayor", sizeTop: 13, secondLine: beacon.mayor.description, sizeBottom: 13, color: .black)
        minorLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Minor", sizeTop: 13, secondLine: beacon.minor.description, sizeBottom: 13, color: .black)
        
        
        
        proximityLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Proximity", sizeTop: 13, secondLine: beacon.proximity.description, sizeBottom: 13, color: .black)
        
        rrsiLabel.attributedText = createDoubleLineTextForLabel(firstLine: "RRSI", sizeTop: 13, secondLine: beacon.rrsi.description, sizeBottom: 13, color: .black)
        
        distanceLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Distance", sizeTop: 13, secondLine: beacon.distance.description, sizeBottom: 13, color: .black)
        timeLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Time", sizeTop: 13, secondLine: beacon.time.description, sizeBottom: 13, color: .black)
        
        
        clproximityLabel.attributedText = createDoubleLineTextForLabel(firstLine: "ClProx", sizeTop: 13, secondLine: beacon.clproximity.rawValue.description, sizeBottom: 13, color: .black)
//        if beacon.isSelected {
//            self.checkView.backgroundColor = .green
//        } else {
//            self.checkView.backgroundColor = .white
//
//        }
        
        self.checkView.isHidden = !beacon.isSelected
        
        if beacon.isInDesiredDistanceAndTime {
            self.contentView.backgroundColor = .green
        } else {
            self.contentView.backgroundColor = .white

        }
        
        if beacon.isInDesiredDistance {
            distanceLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Distance", sizeTop: 13, secondLine: beacon.distance.description, sizeBottom: 13, color: .red)
        } else {
            distanceLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Distance", sizeTop: 13, secondLine: beacon.distance.description, sizeBottom: 13, color: .black)
        }
        
//        distanceTextField.text = beacon.distance.description
//        timeTextField.text = beacon.time.description
        
    }
    @IBAction func setDistance(_ sender: Any) {
        if let distance = distanceTextField.text {
            if distance != "" {
            beacon?.distance = Double(distance) ?? 0
            }
        }
    }
    
    @IBAction func setTime(_ sender: Any) {
        if let time = timeTextField.text {
            beacon?.time = Double(time) ?? 0
        }
    }
}
