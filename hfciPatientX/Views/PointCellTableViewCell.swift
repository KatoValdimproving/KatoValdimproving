//
//  PointCellTableViewCell.swift
//  hfciPatientX
//
//  Created by user on 29/09/21.
//

import UIKit

class PointCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationDesc: UILabel!
    @IBOutlet weak var floor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
