//
//  PaintingBeaconViewController.swift
//  hfciPatientX
//
//  Created by developer on 31/10/21.
//

import UIKit

class PaintingBeaconViewController: UIViewController {
    
    @IBOutlet weak var goToPaintingButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popView: UIView!
    var painting: Painting?
    var didPressYes: ((_ painting: Painting)->())?
    var didPressNo: ((_ painting: Painting)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popView.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 10
        goToPaintingButton.layer.cornerRadius = 5
        titleLabel.text = "Do you want to learn more about the painting: Calendar"
        
        self.backgroundView.frame = UIScreen.main.bounds
        // Do any additional setup after loading the view.
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.alpha = 0.7
        }
        if let paint = self.painting {
            setPaintingInfo(painting: paint)
        }
    }
    
    @IBAction func okAction(_ sender: Any) {
        //  self.dismiss(animated: true)
        if let painting = self.painting {
            self.didPressYes?(painting)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func noAction(_ sender: Any) {
        if let painting = self.painting {
            self.didPressNo?(painting)
            self.dismiss(animated: true)
        }
    }
    func setPaintingInfo(painting: Painting) {
        imageView.image = UIImage(named: painting.title)
        titleLabel.text = "Do you want to learn more about the painting: \(painting.title)"
        self.painting = painting
    }
    
    override func viewDidLayoutSubviews() {
        // self.backgroundView.frame = UIScreen.main.bounds
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
