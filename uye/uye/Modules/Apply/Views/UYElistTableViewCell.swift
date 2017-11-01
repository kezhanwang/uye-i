//
//  UYElistTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/31.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYElistTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellAccessoryDisclosureIndicator()
        setSelectedBackgroundViewLightGray()
    }

    
}
