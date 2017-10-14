//
//  UYUserTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/14.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYUserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var areaView: UIView!
    
    @IBOutlet weak var areaLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        areaView.layer.cornerRadius = 11
        areaView.layer.masksToBounds = true
        setCellAccessoryDisclosureIndicator()
        
    }
    
}
