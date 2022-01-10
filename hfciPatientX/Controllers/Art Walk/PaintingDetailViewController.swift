//
//  PaintingDetailViewController.swift
//  hfciPatientX
//
//  Created by developer on 14/10/21.
//

import UIKit
import DropDown

class PaintingDetailViewController: UIViewController {

//    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var mapViewController: MapViewController?
    var painting: Painting!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     //   self.titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Simbiosis", sizeTop: 27, secondLine: "Hanna Frost", sizeBottom: 17, color: .black)
       // self.mapViewController?.beacon = getBeaconByPaintiingTitle(title: self.painting.title)
        self.backButton.layer.cornerRadius = 10
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1
        
        self.mapViewController?.painting = painting
        imageView.layer.cornerRadius = 10
        self.textView.textContainer.lineFragmentPadding = 0
//        navigateButton.layer.cornerRadius = 10
      //  backButton.layer.borderColor = UIColor.black.cgColor
       // backButton.layer.borderWidth = 2
        //backButton.layer.cornerRadius = 10
        setInfoWithPainting(painting: self.painting)
       // self.mapViewController?.showGoToArtwalkButton(isHidden: false)
        self.mapViewController?.paintingDetailViewController = self
    }
    
    func setInfoWithPainting(painting: Painting) {
        self.titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: painting.title, sizeTop: 27, secondLine: painting.author , sizeBottom: 17, color: .black)
        self.textView.text = painting.text
        self.imageView.image = UIImage(named: painting.title)
        
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.mapViewController?.showGoToArtwalkButton(isHidden: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
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
    
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.flowLayout.invalidateLayout()
//        navigateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
      //  self.mapViewController?.showGoToArtwalkButton(isHidden: false)
        self.mapViewController?.showGoToArtwalkButton(isHidden: false)


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
