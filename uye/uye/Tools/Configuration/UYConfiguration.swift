//
//  UYConfiguration.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import SystemConfiguration

/**
 应该看看一下的第三方们
 PermissionScope //获取用户权限的请求
 Moya //结合SwiftyJSON和Alamofire的封装网络请求
 DeviceKit //获取设备信息
 GDPerformanceView //调试使用，可以展示FPS，CPU 使用情况
 */
//

// MARK: - 常量

// MARK: 第三方常Key量
let mapKey = "nXTHL3YFSXWmk1AQmG7nvO3Qa2AKiyPD"

let MakeOrderSuccess = NSNotification.Name(rawValue:"com.uy.order.success")
let LoginStatusChange = NSNotification.Name("com.uy.login.changed")
/// 默认cell的距左侧间隙
let spaceWidth :CGFloat = 15

/// 状态栏高度（非iPhone X：StatusBar 高20px,iPhone X：StatusBar 高44px）
let kStatusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.size.height

/// navigationbar高度
let kNavBarHeight:CGFloat = 44.0

let kNavigationHeight:CGFloat = kStatusBarHeight + kNavBarHeight
/// tabbarController高度 （非iPhone X：底部TabBar高49px,iPHone X：底部高度83px）
let kTabBarHeight:CGFloat = kStatusBarHeight > 20 ? 83 : 49



/// 屏幕宽度
let kScreenWidth :CGFloat = UIScreen.main.bounds.width

/// 屏幕高度
let kScreenHeight :CGFloat = UIScreen.main.bounds.height

/// 输入表格cell的高度
let kIputCellHeight :CGFloat = 45

/// 输入表格cell的标题最大宽度
let kInputCellLabelWidth = 80 - spaceWidth

//com.bjzt.uye













// MARK: - URL
/// 客服电话
let customerServicePhone = "400-002-9691"




// MARK: - 设备信息
let deviceName = UIDevice.current.name  //获取设备名称 例如：课栈的手机
let sysName = UIDevice.current.systemName //获取系统名称 例如：iPhone OS
let sysVersion = UIDevice.current.systemVersion //获取系统版本 例如：9.2
let deviceUUID = UIDevice.current.identifierForVendor?.uuidString  //获取设备唯一标识符 例如：FBF2306E-A0D8-4F4B-BDED-9333B627D3E6
let deviceModel = UIDevice.current.model //获取设备的型号 例如：iPhone
let devName = UIDevice.current.modelName


// MARK: - 版本信息
let infoDic = Bundle.main.infoDictionary

/// 本地版本号
let localAppVersion = "101"

let appVersion = infoDic?["CFBundleShortVersionString"] as! String// 获取App的版本
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

/// 获取wifi的mac地址以及ssid
func getMAC()->(success:Bool,ssid:String,mac:String){
    
    if let cfa:NSArray = CNCopySupportedInterfaces() {
        for x in cfa {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                let ssid = dict["SSID"]!
                let mac  = dict["BSSID"]!
                return (true,ssid as! String,mac as! String)
            }
        }
    }
    return (false,"","")
}





