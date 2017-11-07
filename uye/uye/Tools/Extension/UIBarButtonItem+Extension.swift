//
//  UIBarButtonItem+Extension.swift
//  kezhan
//
//  Created by Tintin on 2017/5/6.
//  Copyright © 2017 KeZhan. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 快捷初始化导航栏按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - fontSize: 字号大小
    ///   - target: target
    ///   - action: action
    convenience init(title:String,fontSize:CGFloat = 16,target:Any?,action:Selector,isBack :Bool = false) {
        let btn = UIButton(type: .custom)
        
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(UIColor.navigationBarTintColor, for: .normal)
        btn.addTarget(target, action: action, for: .touchUpInside)
//        btn.backgroundColor = UIColor.randomColor
        if isBack {
            btn.setImage(UIImage(named: "bacn_icon"), for: .normal)
        }
        btn.sizeToFit()
        if isBack {
            btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        }
        self.init(customView: btn)
        
        
    }
    class func backBarButton(target:Any?,action:Selector) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "bacn_icon"), for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50)
        btn.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
        
    }
  
    
}
