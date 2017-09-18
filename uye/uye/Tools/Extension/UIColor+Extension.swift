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
    class func randomColor() -> UIColor {
        return UIColor.init(red: CGFloat(arc4random()%255)/255.0, green: CGFloat(arc4random()%255)/255.0, blue: CGFloat(arc4random()%255)/255.0, alpha: 1)
    }
    
    /// 快捷设置Color的方法,不需要自己写`/255.0`了
    ///
    /// - Parameters:
    /// - alpha: 默认是 1
    /// - Returns: UIColor
    class func RGBColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    
// MARK: - 课栈配置的一些颜色
    
// MARK: 主题颜色
    class func themeColor() -> UIColor {
        return RGBColor(red: 33, green: 171, blue: 242)
    }
    
    // MARK: 文字的黑色
    /// 文字黑色 51、51、51
    class func blackTextColor() -> UIColor {
        return RGBColor(red: 51, green: 51, blue: 51)
    }
    
    /// 灰色字体 80、80、80
    class func grayTextColor() -> UIColor {
        return RGBColor(red: 80, green: 80, blue: 80)
    }
    /// 灰色字体 141、141、141
    class func lightGrayTextColor() -> UIColor {
        return RGBColor(red: 141, green: 141, blue: 141)
    }
    
    
    // MARK: ViewController的View的灰色背景,tableView的背景色等
    // 238、238、238
    class func grayViewColor() -> UIColor {
        return RGBColor(red: 238, green: 238, blue: 238)
    }
    
    // MARK: tableViewCell的选中的颜色等
    // 247、247、247
    class func lightGrayViewColor() -> UIColor {
        return RGBColor(red: 247, green: 247, blue: 247)
    }
}
