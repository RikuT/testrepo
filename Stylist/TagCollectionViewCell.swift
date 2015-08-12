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
    @IBOutlet weak var titleView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //postsLabel.textAlignment = NSTextAlignment.Center
        //profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        titleView.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 0.75)
        tagNameLabel?.textColor = UIColor.whiteColor()
    }

    
}
