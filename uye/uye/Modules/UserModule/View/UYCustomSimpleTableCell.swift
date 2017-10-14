//
//  UYCustomSimpleTableCell.swift
//  uye
//
//  Created by Tintin on 2017/10/14.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYCustomSimpleTableCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellAccessoryDisclosureIndicator()
        setSelectedBackgroundViewLightGray()
    }


    
}
