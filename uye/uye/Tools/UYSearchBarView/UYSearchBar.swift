//
//  UYSearchBar.swift
//  uye
//
//  Created by Tintin on 2017/10/23.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYSearchBar: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexColor: "f2f2f2")
        font = UIFont.systemFont(ofSize: 15)
        placeholder = "请输入您要搜索的机构名称"
        leftView = UIImageView(image: #imageLiteral(resourceName: "search_icon"))
        borderStyle = UITextBorderStyle.none
        returnKeyType = UIReturnKeyType.search
        leftViewMode = UITextFieldViewMode.always
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var oryLeftRect = super.leftViewRect(forBounds: bounds)
        oryLeftRect.origin.x = oryLeftRect.origin.x + 10
        return oryLeftRect
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
