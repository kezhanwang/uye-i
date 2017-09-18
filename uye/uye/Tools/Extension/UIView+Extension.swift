//
//  UIView+Extension.swift
//  kezhan
//
//  Created by Tintin on 2017/5/15.
//  Copyright © 2017 KeZhan. All rights reserved.
//

import UIKit
extension UIView {
    
    /// 创建一条分割线
    class func lineView(frame :CGRect) -> UIView {
        let alineView = UIView(frame: frame)
        alineView.backgroundColor = UIColor.groupTableViewBackground// UIColor.grayViewColor()
        return alineView
    }
}
