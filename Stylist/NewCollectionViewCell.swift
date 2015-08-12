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
    @IBOutlet weak var heightSexLabel: UILabel!
    @IBOutlet weak var heartIcon: UIImageView!
    
    var complition:((Void) -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //postsLabel.textAlignment = NSTextAlignment.Center
        bottomBlurView.backgroundColor = UIColor(red: 0, green: 0.698, blue: 0.792, alpha: 0.75)
        votesLabel!.textAlignment = NSTextAlignment.Center

        
        heartIcon?.hidden = true
        //profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
    }
    
    func onDoubleTap()  {
        if self.complition != nil
        {
            self.complition!()
        }
        heartIcon?.hidden = false
        heartIcon?.alpha = 1.0
        
        UIView.animateWithDuration(1.0, delay:1.0, options:nil, animations: {
            self.heartIcon?.alpha = 0
            }, completion: {
                (value:Bool) in
                self.heartIcon?.hidden = true
        })
    }
    
}
