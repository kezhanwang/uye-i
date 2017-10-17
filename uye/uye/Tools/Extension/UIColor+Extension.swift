//
//  UIColor+Extension.swift
//  kezhan
//
//  Created by Tintin on 2017/5/7.
//  Copyright © 2017 KeZhan. All rights reserved.
//

import UIKit

extension UIColor {
// MARK: - 一些快捷设置Color的方法
    /// 随机颜色，用于调试使用
    ///
    /// - Returns: 随机颜色
    class var randomColor : UIColor {
        return UIColor.init(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: 1)
    }
    
    /// 16进制颜色
    ///
    convenience init(hexColor: String) {
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: hexColor[0..<2]).scanHexInt32(&red)
        
        Scanner(string: hexColor[2..<4]).scanHexInt32(&green)
        
        Scanner(string: hexColor[4..<6]).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    /// 快捷设置Color的方法,不需要自己写`/255.0`了
    ///
    /// - Parameters:
    /// - alpha: 默认是 1
    /// - Returns: UIColor
    class func RGBColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    
// MARK: - U业配置的一些颜色
    
    /// 主题颜色
    class var themeColor:UIColor {
        return UIColor(hexColor: "00c29a")
    }
    /// Controller的背景颜色
    class var background :UIColor {
        return UIColor(hexColor:"f4f4f4")
    }
    class var lightBackground :UIColor {
        return UIColor(hexColor:"f2f2f2")
    }
    ///大部分文字颜色
    class var blackText :UIColor {
        return UIColor(hexColor: "232323")
//        return UIColor(hexColor: "646464")
    }
    ///灰色字体
    class var darkGrayText :UIColor {
        return UIColor(hexColor: "999999")
    }
    ///灰色字体
    class var grayText :UIColor {
        return UIColor(hexColor: "a5a5a5")
    }
    /// navigationbar的字体按钮颜色
    class var navigationBarTintColor :UIColor {
        return UIColor(hexColor: "484848")
    }
    /// tabbar的主题颜色
    class var tabBarTint :UIColor {
        return UIColor(hexColor: "00b496")
    }
    /// 分割线的颜色
    class var lineGray : UIColor {
        return UIColor(hexColor: "cccccc")
    }
    /// 头像的背景颜色
    class var avatarBackground :UIColor {
        return UIColor(hexColor: "ebebeb")
    }
    /// 头像边框颜色
    class var avatarBorder:UIColor {
        return UIColor(hexColor: "dfdfdf")
    }
    /// 地区黄色背景
    class var areaOrangeBack: UIColor {
        return UIColor(hexColor: "ffac29")
    }
    /// 地区灰色背景
    class var areaGrayBack: UIColor {
        return UIColor(hexColor: "e0e0e0")
    }
    /// 地区边框颜色
    class var areaBorder: UIColor {
        return UIColor(hexColor: "d5d5d5")
    }
    
    /// 分类标记颜色
    class var blueTextColor: UIColor {
        return UIColor(hexColor: "39aefb")
    }
    /// 按钮不可以点击的文字颜色
    class var disableTextColor: UIColor {
        return UIColor(hexColor: "cecece")
    }
    
    /// 按钮不可以点击的背景色
    class var disableBackColor: UIColor {
        return UIColor(hexColor: "d2d2d2")
    }
    

    
    

}
