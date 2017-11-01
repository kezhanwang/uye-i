//
//  AppDelegate.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mapManager = BMKMapManager()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        
        window?.rootViewController = UYTabBarController()
        window?.makeKeyAndVisible()
        //百度地区
        mapManager.start(mapKey, generalDelegate: nil)
        //开启定位
        UYLocationManager.shared.requstAuthorization()
        //开始键盘输入监控
        IQKeyboardManager.sharedManager().enable = true
        //版本更新
//        UYAPPManager.shared.checkAPPVersion()
        return true
    }
    
}

