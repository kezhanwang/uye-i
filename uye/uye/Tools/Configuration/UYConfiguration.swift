//
//  UYConfiguration.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

// MARK: - 常量
/// 导航栏高度
let navigationBarHeight :CGFloat = 64

/// tabbar高度
let tabbarHeight :CGFloat = 49

/// 默认cell的距左侧间隙
let spaceWidth :CGFloat = 15

/// 屏幕宽度
let kScreenWidth :CGFloat = UIScreen.main.bounds.width

/// 屏幕高度
let kScreenHeight :CGFloat = UIScreen.main.bounds.height

/// 输入表格cell的高度
let kIputCellHeight :CGFloat = 45

/// 输入表格cell的标题最大宽度
let kInputCellLabelWidth = 80 - spaceWidth










// MARK: - URL
/// 客服电话
let customerServicePhone = "4000029691"

/// 关于我们的url
let aboutUsURLString = "http://api2.kezhanwang.cn/html/about/about.html"

/// 注册协议
let reigsterAgreementURLString = "http://api2.kezhanwang.cn/html/reg_h5/reg.html"

/// 常见问题的URL
let commonProblemsURLString = "http://pay.kezhanwang.cn/app/apploan/question"


// MARK: - 设备信息

let deviceName = UIDevice.current.name  //获取设备名称 例如：课栈的手机
let sysName = UIDevice.current.systemName //获取系统名称 例如：iPhone OS
let sysVersion = UIDevice.current.systemVersion //获取系统版本 例如：9.2
let deviceUUID = UIDevice.current.identifierForVendor?.uuidString  //获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
let deviceModel = UIDevice.current.model //获取设备的型号 例如：iPhone
public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

let devName = UIDevice.current.modelName


// MARK: - 版本信息
let infoDic = Bundle.main.infoDictionary
let appVersion = infoDic?["CFBundleShortVersionString"] // 获取App的版本
let appBuildVersion = infoDic?["CFBundleVersion"] // 获取App的build版本
let appName = infoDic?["CFBundleDisplayName"] // 获取App的名称


// MARK: - 方法
func IS_IOS8() -> Bool {
    return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
}

/// 版本号是否大于等于某版本号
func iOSVersionGreaterThan(version:Double) -> Bool {
    return (UIDevice.current.systemVersion as NSString).doubleValue >= version
}
/// 版本号是否小于某版本号
func iOSVersionLessThan(version:Double) -> Bool {
    return (UIDevice.current.systemVersion as NSString).doubleValue < version
}
