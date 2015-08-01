//
//  NewCollectionViewCell.swift
//  Stylist
//
//  Created by Kenty on 2015/07/28.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit
import ParseUI
import Parse



class NewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postsImageView: PFImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var votesLabel:UILabel?
    @IBOutlet var likeButton: UIButton!
    
    var complition:((Void) -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postsLabel.textAlignment = NSTextAlignment.Center
        
    }
    
    
    @IBAction func vote(sender: AnyObject) {
        
        if self.complition != nil
        {
            self.complition!()
        }
    }
}