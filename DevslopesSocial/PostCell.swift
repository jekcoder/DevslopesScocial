//
//  PostCell.swift
//  DevslopesSocial
//
//  Created by John Kine on 2016-11-23.
//  Copyright © 2016 John Kine. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg:UIImageView!
    @IBOutlet weak var usernameLbl:UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption:UITextView!
    @IBOutlet weak var likesLbl:UILabel!

    var post:Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    
    func configureCell(post:Post) {
        
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
    }

}
