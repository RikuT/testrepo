//
//  SingleRowCellC.swift
//  Stylist
//
//  Created by Kenty on 2015/07/24.
//  Copyright (c) 2015年 xxx. All rights reserved.
//



import UIKit
import ParseUI

class SingleRowCell: UICollectionViewCell {
    @IBOutlet weak var topsImageView: PFImageView!
    @IBOutlet weak var topsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topsLabel.textAlignment = NSTextAlignment.Center

    }}




