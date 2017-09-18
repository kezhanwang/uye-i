//
//  UITableViewCell+Extension.swift
//  kezhan
//
//  Created by Tintin on 2017/5/10.
//  Copyright © 2017 KeZhan. All rights reserved.
//

import UIKit
extension UITableViewCell {
    
    /// 设置cell选中之后是浅灰色
    func setSelectedBackgroundViewLightGray()  {
        let selectedView = UIView(frame: bounds)
        selectedView.backgroundColor = UIColor.lightGrayViewColor()
        self.selectedBackgroundView = selectedView
    }
    func setCellAccessoryDisclosureIndicator() {
        accessoryView = UIImageView(image: UIImage(named: "cell_accessory_Indicator_icon"))
    }
}
