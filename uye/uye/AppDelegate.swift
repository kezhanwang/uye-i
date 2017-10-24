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
        mapManager.start(mapKey, generalDelegate: nil)
        UYLocationManager.shared.requstAuthorization()
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        UYLocationManager.shared.beginUpdataLocation()
    }
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//    }



}

