//
//  KZTabBarController.swift
//  kezhan
//
//  Created by Tintin on 2017/5/2.
//  Copyright © 2017 KeZhan. All rights reserved.
//

import UIKit

class KZTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNavi = KZNavigationController(rootViewController: KZHomeViewController())
        homeNavi.tabBarItem = UITabBarItem(title: "首页", image: tabbbarImage(imageName: "tabbar_home_normal"), selectedImage: tabbbarImage(imageName: "tabbar_home_select"))
        
        
        let findNavi = KZNavigationController(rootViewController: KZFindViewController())
        findNavi.tabBarItem = UITabBarItem(title: "发现", image: tabbbarImage(imageName: "tabbar_find_normal"), selectedImage: tabbbarImage(imageName: "tabbar_find_select"))
        
        
        let finacialNavi = KZNavigationController(rootViewController: KZFinacialViewController())
         finacialNavi.tabBarItem = UITabBarItem(title: "金融", image: tabbbarImage(imageName: "tabbar_finacial_normal"), selectedImage: tabbbarImage(imageName: "tabbar_finacial_select"))
        finacialNavi.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.kz_fontWithSize(size: 11)], for: .normal)

        
        let userNavi = KZNavigationController(rootViewController: KZUserViewController())
        userNavi.tabBarItem = UITabBarItem(title: "我的", image: tabbbarImage(imageName: "tabbar_user_normal"), selectedImage: tabbbarImage(imageName: "tabbar_user_select"))
        userNavi.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.kz_fontWithSize(size: 11)], for: .normal)
        
        let VCArray = [homeNavi,findNavi,finacialNavi,userNavi]
        viewControllers = VCArray
        tabBar.tintColor = UIColor.init(red: 29.0/255, green: 166.0/255, blue: 237.0/255, alpha: 1)
    }
    func tabbbarImage(imageName:String) -> UIImage {
       return UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal)
    }
}
