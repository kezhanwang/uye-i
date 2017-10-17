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
    func setupUI()  {
        
        let url = URL(string: UYAPPManager.shared.userInfo?.head_protrait ?? "")
        avatarView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "user_avatar_icon"))
        nameLabel.text = UYAPPManager.shared.userInfo?.username
        
        areaLabel.text  = UYAPPManager.shared.userInfo?.active_city ?? "未知"
        if areaLabel.text == "未知" {
            areaView.backgroundColor = UIColor.areaGrayBack
        }else{
            areaView.backgroundColor = UIColor.areaOrangeBack
        }
        
    }
    
}
