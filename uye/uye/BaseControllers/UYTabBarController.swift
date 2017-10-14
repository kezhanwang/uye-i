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
        
        let findNavi = UYNavigationController(rootViewController: UYEmployViewController())
        findNavi.tabBarItem = UITabBarItem(title: "就业帮", image: tabbbarImage(imageName: "tabbar_finacial_normal"), selectedImage: tabbbarImage(imageName: "tabbar_finacial_select"))
        
        let userNavi = UYNavigationController(rootViewController: UYUserViewController())
        userNavi.tabBarItem = UITabBarItem(title: "我的", image: tabbbarImage(imageName: "tabbar_user_normal"), selectedImage: tabbbarImage(imageName: "tabbar_user_select"))
        
        let VCArray = [homeNavi,findNavi,userNavi]
        viewControllers = VCArray
        tabBar.barTintColor = UIColor.white
        tabBar.tintColor = UIColor.tabBarTint;
    }
    
    func tabbbarImage(imageName:String) -> UIImage {
        return UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal)
    }
}
