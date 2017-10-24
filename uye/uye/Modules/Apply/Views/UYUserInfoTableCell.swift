//
//  UYUserInfoTableCell.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYUserInfoTableCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setSelectedBackgroundViewLightGray()
    }
    func setupUI(itemInfo:UYUserStatusModel) {
        iconImageView.image = UIImage(named: itemInfo.itemIcon!)
        titleLabel.text = itemInfo.title
        detailLabel.text = itemInfo.detail
        if itemInfo.isCertified {
            statusLabel.text = "已完成"
            statusLabel.textColor = UIColor.grayText
        }else{
            statusLabel.textColor = UIColor.red
            
            if itemInfo.isOptional {
                statusLabel.text = "可认证"
            }else{
                
                statusLabel.text = "待认证"
            }
        }
        
    }
}
