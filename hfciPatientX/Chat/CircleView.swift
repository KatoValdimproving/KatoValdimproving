//
//  RoundedView.swift
//  NovaTrack
//
//  Created by Juan Pablo Rodriguez Medina on 06/03/20.
//  Copyright © 2020 Paul Zieske. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2.0
        self.layer.masksToBounds = true
    }
}


