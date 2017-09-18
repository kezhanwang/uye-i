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
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.lightGrayTextColor(), for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        if isBack {
            btn.setImage(#imageLiteral(resourceName: "navi_back"), for: .normal)
        }
        
        btn.sizeToFit()
        self.init(customView: btn)
        
    }
}
