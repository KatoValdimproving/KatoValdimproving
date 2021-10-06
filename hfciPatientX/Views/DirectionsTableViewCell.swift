//
//  DirectionsTableViewCell.swift
//  hfciPatientX
//
//  Created by user on 05/10/21.
//

import UIKit

class DirectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var directionLBL: UILabel!
    @IBOutlet weak var directionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
