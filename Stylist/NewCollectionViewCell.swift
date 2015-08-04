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
    @IBOutlet weak var profileImageView: PFImageView!
   // @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var votesLabel:UILabel?
    @IBOutlet weak var userName:UILabel?
    @IBOutlet weak var bottomBlurView: UIView!
    
    var complition:((Void) -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //postsLabel.textAlignment = NSTextAlignment.Center
        bottomBlurView.backgroundColor = UIColor(white: 1, alpha: 0.4)
        votesLabel!.textAlignment = NSTextAlignment.Left

        
    }
    
    
    @IBAction func vote(sender: AnyObject) {
        
        if self.complition != nil
        {
            self.complition!()
        }
    }
}