//
//  TourPaintingDetailViewController.swift
//  hfciPatientX
//
//  Created by user on 31/01/22.
//

import UIKit
import DropDown

class TourPaintingDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    var mapViewController: MapViewController?
    var previous: Painting?
    var painting: Painting!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(endTour), name: Notification.Name("endGuidedTour"), object: nil)
        
        self.backButton.layer.cornerRadius = 10
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1
        
        self.mapViewController?.painting = painting
        imageView.layer.cornerRadius = 10
        self.textView.textContainer.lineFragmentPadding = 0
        setInfoWithPainting(painting: self.painting)
        self.mapViewController?.tourPaintingDetailViewController = self
        
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        textView.isSelectable = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = .link
        
        self.mapViewController?.goToArtWalkPaintingAction(self)
        
        if(previous == nil){
            self.backButton.isEnabled = false
        }
        
    }
    
    func setInfoWithPainting(painting: Painting) {
        self.titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: painting.title, sizeTop: 27, secondLine: painting.author , sizeBottom: 17, color: .black)
        self.textView.text = painting.text
        self.imageView.image = UIImage(named: painting.title)
        
    }
    
    @IBAction func nextPaint(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        if ((self.mapViewController?.gidedArtTour) != nil && self.mapViewController!.gidedArtTour){
            self.mapViewController?.nextStop()
        }else{
            self.mapViewController?.galleryViewController?.endTour()
        }
    }
    
    @objc func endTour(){
        backButton.isEnabled = false
        nextButton.setTitle("Finish", for: .normal)
    }
    
    @IBAction func previousPaintingInfo(_ sender: Any) {
        if(previous != nil){
            self.performSegue(withIdentifier: "previousPicture", sender: self)
        }
    }
    
    func pushDirectionsView(directionsString: [String], fromMenu: DropDown, toMenu: DropDown) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let directionsViewController = storyboard.instantiateViewController(withIdentifier: "DirectionsViewController") as? DirectionsViewController {
            directionsViewController.directionsString = directionsString
            directionsViewController.menu = fromMenu
            directionsViewController.menuTwo = toMenu
            directionsViewController.mapViewcontroller = self.mapViewController
            directionsViewController.painting = self.painting
            self.navigationController?.pushViewController(directionsViewController, animated: true)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let paintingDetailViewController = segue.destination as? PreviousPaintingDetailViewController
        paintingDetailViewController?.painting = previous
    }
    

}
