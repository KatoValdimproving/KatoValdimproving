//
//  TableViewCell.swift
//  hfciPatientX
//
//  Created by user on 15/09/21.
//

import UIKit
import DropDown

class CustomCell: DropDownCell {
    
    @IBOutlet var downArrow : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        downArrow.contentMode = .scaleAspectFit
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
