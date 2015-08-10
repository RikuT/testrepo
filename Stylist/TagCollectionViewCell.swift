//
//  TagCollectionViewCell.swift
//  Stylist
//
//  Created by 田畑リク on 2015/08/10.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagImageView: PFImageView!
    @IBOutlet weak var tagImageView2: PFImageView!
    @IBOutlet weak var tagNameLabel:UILabel?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //postsLabel.textAlignment = NSTextAlignment.Center
        //profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
    }

    
}
