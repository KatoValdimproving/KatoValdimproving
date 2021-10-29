//
//  PaintingDetailViewController.swift
//  hfciPatientX
//
//  Created by developer on 14/10/21.
//

import UIKit

class PaintingDetailViewController: UIViewController {

    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Simbiosis", sizeTop: 27, secondLine: "Hanna Frost", sizeBottom: 17, color: .black)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
        imageView.layer.cornerRadius = 10
        self.textView.textContainer.lineFragmentPadding = 0
        navigateButton.layer.cornerRadius = 10
      //  backButton.layer.borderColor = UIColor.black.cgColor
       // backButton.layer.borderWidth = 2
        //backButton.layer.cornerRadius = 10
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.flowLayout.invalidateLayout()
        navigateButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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