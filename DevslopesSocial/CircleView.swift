//
//  CircleView.swift
//  DevslopesSocial
//
//  Created by John Kine on 2016-11-23.
//  Copyright © 2016 John Kine. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
            layer.cornerRadius = self.frame.width / 2
    }
}
