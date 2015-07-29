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

var parseObject:PFObject?

class NewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var postsImageView: PFImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var votesLabel:UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postsLabel.textAlignment = NSTextAlignment.Center
        
    }


    @IBAction func vote(sender: AnyObject) {
        
        if (parseObject != nil) {
            if var votes:Int? = parseObject!.objectForKey("votes") as? Int {
                votes!++
                
                parseObject!.setObject(votes!, forKey: "votes")
                parseObject!.saveInBackgroundWithTarget(nil, selector: nil)
                
                votesLabel?.text = "\(votes!) votes"
    }


        }}}