//
//  UYUncheckView.swift
//  uye
//
//  Created by Tintin on 2017/11/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYUncheckView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        let color = UIColor.lineGray
        color.set() // 设置线条颜色
        let aPath = UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: bounds.width-2, height: bounds.height-2))
        aPath.lineWidth = 1.0
        aPath.stroke()
    }

}
