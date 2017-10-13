//
//  UYTabBarController.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNavi = UYNavigationController(rootViewController: UYHomeViewController())
        homeNavi.tabBarItem = UITabBarItem(title: "首页", image: tabbbarImage(imageName: "tabbar_home_normal"), selectedImage: tabbbarImage(imageName: "tabbar_home_select"))
        homeNavi.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.kz_fontWithSize(size: 11)], for: .normal)
        
        let findNavi = UYNavigationController(rootViewController: UYEmployViewController())
        findNavi.tabBarItem = UITabBarItem(title: "就业帮", image: tabbbarImage(imageName: "tabbar_finacial_normal"), selectedImage: tabbbarImage(imageName: "tabbar_finacial_select"))
        findNavi.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.kz_fontWithSize(size: 11)], for: .normal)
        
        let userNavi = UYNavigationController(rootViewController: UYUserViewController())
        userNavi.tabBarItem = UITabBarItem(title: "我的", image: tabbbarImage(imageName: "tabbar_user_normal"), selectedImage: tabbbarImage(imageName: "tabbar_user_select"))
        userNavi.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.kz_fontWithSize(size: 11)], for: .normal)
        
        let VCArray = [homeNavi,findNavi,userNavi]
        viewControllers = VCArray
        tabBar.tintColor = UIColor.init(red: 29.0/255, green: 166.0/255, blue: 237.0/255, alpha: 1)
    }
    func tabbbarImage(imageName:String) -> UIImage {
        return UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal)
    }
}
