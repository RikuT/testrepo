//
//  SingleRowCell.swift
//  Stylist
//
//  Created by Kenty on 2015/06/29.
//  Copyright (c) 2015年 xxx. All rights reserved.
//

import UIKit

class SingleRowCell: UITableViewCell {
    
    @IBOutlet weak var topsImageView: UIImageView!
    @IBOutlet weak var topsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
