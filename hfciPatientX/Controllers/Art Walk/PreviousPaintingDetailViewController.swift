//
//  PreviousPaintingDetailViewController.swift
//  hfciPatientX
//
//  Created by user on 31/01/22.
//

import UIKit

class PreviousPaintingDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var painting: Painting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.backButton.layer.cornerRadius = 10
        backButton.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderWidth = 1
        
        imageView.layer.cornerRadius = 10
        self.textView.textContainer.lineFragmentPadding = 0
        setInfoWithPainting(painting: self.painting)
        
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        textView.isSelectable = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = .link
    }
    
    func setInfoWithPainting(painting: Painting) {
        self.titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: painting.title, sizeTop: 27, secondLine: painting.author , sizeBottom: 17, color: .black)
        self.textView.text = painting.text
        self.imageView.image = UIImage(named: painting.title)
        
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
