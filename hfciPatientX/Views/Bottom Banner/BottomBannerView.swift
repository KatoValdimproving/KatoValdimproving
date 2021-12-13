//
//  BottomBannerView.swift
//  hfciPatientX
//
//  Created by developer on 12/12/21.
//

import UIKit

class BottomBannerView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static func formatLabel(paintTitle: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.white,
        ]
        
        let attributedQuote = NSMutableAttributedString(string: "You have arrived at ", attributes: attributes)
        
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 19),
            .foregroundColor: UIColor.white,
        ]
        
        let title = NSAttributedString(string: paintTitle, attributes: attributes2)
        
        attributedQuote.append(title)
        return attributedQuote
    }
    
    override func awakeFromNib() {
        self.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.maxY, width: 400, height: 50)
        self.titleLabel.layer.cornerRadius = 10
        self.layer.cornerRadius = 10
    }

    
    func show(_ show:Bool) {
       // self.endEditing(true)
      
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.frame.origin.y = show ? UIScreen.main.bounds.height - 200 : UIScreen.main.bounds.height + 200
        }
    }
    
    static func instantiate() -> BottomBannerView? {
        if let bottomBannerView = UINib(nibName: "BottomBannerView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? BottomBannerView {
            bottomBannerView.layer.cornerRadius = 10
            bottomBannerView.titleLabel.layer.cornerRadius = 10
            return bottomBannerView
        }
        
        return nil
    }
}
