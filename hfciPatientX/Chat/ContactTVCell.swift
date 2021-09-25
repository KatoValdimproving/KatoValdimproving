//
//  ContactTVCell.swift
//  NovaTrack
//
//  Created by Juan Pablo Rodriguez Medina on 06/03/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import UIKit

class ContactTVCell: UITableViewCell {
    @IBOutlet weak var statusIndicatorView: CircleView!
    @IBOutlet weak var initialsButton: UIButton!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var unreadBadgeView: CircleView!
    @IBOutlet weak var unreadCountLabel: UILabel!
    
    var didTapInitialsButton:((_ sender:UITableViewCell) -> Void)?
    
    func setUnreadCount(_ count:Int) {
        if count > 0 {
            self.unreadBadgeView.isHidden = false
            self.unreadCountLabel.text = "\(count)"
        }
        else {
            self.unreadBadgeView.isHidden = true
        }
    }
    
    @IBAction func initialsButtonTapped(_ sender: UIButton) {
        self.didTapInitialsButton?(self)
    }
}
