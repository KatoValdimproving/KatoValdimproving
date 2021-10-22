//
//  GalleryCollectionViewCell.swift
//  hfciPatientX
//
//  Created by developer on 12/10/21.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 10
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 10
        bottomView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.2
//        let color = UIColor(red: 21/255, green: 57/255, blue: 109/255, alpha: 1)
//        titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: "Simbiosis", sizeTop: 20, secondLine: "by Hanna Froost", sizeBottom: 15, color: color)
    }
    
    func setInfo(painting: Painting) {
        let color = UIColor(red: 21/255, green: 57/255, blue: 109/255, alpha: 1)

        titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: painting.title, sizeTop: painting.title.count < 27 ? 20 : 17 , secondLine: "by " + painting.author, sizeBottom: 15, color: color)
        if painting.title.count > 30 {
            titleLabel.attributedText = createDoubleLineTextForLabel(firstLine: painting.title, sizeTop: 15 , secondLine: "by " + painting.author, sizeBottom: 15, color: color)
        }
        
        imageView.image = UIImage(named: painting.title)
    }

}
