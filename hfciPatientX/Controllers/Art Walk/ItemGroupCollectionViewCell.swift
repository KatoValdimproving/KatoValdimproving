//
//  ItemGroupCollectionViewCell.swift
//  hfciPatientX
//
//  Created by developer on 15/10/21.
//

import UIKit

class ItemGroupCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 10
      
        
        let color = UIColor.black
        let attributedString = createDoubleLineTextForLabel(firstLine: "Simbiosis", sizeTop: 20, secondLine: "Hanna Froost".capitalized, sizeBottom: 15, color: color)
//        let attributedDescription: [NSAttributedString.Key: Any] = [
//            .baselineOffset: 10]
//        let attributedTitle = NSAttributedString(string: "", attributes: attributedDescription)
//        attributedString.append(attributedTitle)
        
        titleLabel.attributedText = attributedString
        
        
    }
    
}
