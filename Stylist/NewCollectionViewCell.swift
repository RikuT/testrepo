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
            if (parseObject != nil)
            {
                if let votes = parseObject!.objectForKey("votes") as? Int {
                    parseObject!.setObject(votes + 1, forKey: "votes")
                    parseObject!.saveInBackgroundWithTarget(nil, selector: nil)
                    votesLabel?.text = "\(votes + 1) votes"
                }
                else
                {
                    parseObject!.setObject(1, forKey: "votes")
                    parseObject!.saveInBackgroundWithTarget(nil, selector: nil)
                    votesLabel?.text = "1 votes"
                }
            }}}