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
        delegate = self
        let homeNavi = UYNavigationController(rootViewController: UYHomeViewController())
        homeNavi.tabBarItem = UITabBarItem(title: "首页", image: tabbbarImage(imageName: "tabbar_home_normal"), selectedImage: tabbbarImage(imageName: "tabbar_home_select"))
        
        let findNavi = UYNavigationController(rootViewController: UYEmployViewController())
        findNavi.tabBarItem = UITabBarItem(title: "U业帮", image: tabbbarImage(imageName: "tabbar_finacial_normal"), selectedImage: tabbbarImage(imageName: "tabbar_finacial_select"))
        
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
    
    
    func showAppVersionUpdateAlert(version:UYVersionInfo) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "有新版本啦", message: version.desp, preferredStyle: UIAlertControllerStyle.alert)
            alertVC.addAction(UIAlertAction(title: "更新", style: UIAlertActionStyle.default, handler: { (alertAction) in
                if let url = URL(string: "https://itunes.apple.com/cn/app/ke-zhan-jiao-yu-pei-xun-jin/id1026601319?mt=8") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.openURL(url)
                    }
                }
                
                if version.forceUpdate {
                    self.showAppVersionUpdateAlert(version: version)
                }
            }))
            if version.forceUpdate == false {
                alertVC.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
            }
            self.present(alertVC, animated: true, completion: nil)

        }
    }
}

extension UYTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: UYNavigationController.classForCoder()) {
            let naviVC = viewController as! UYNavigationController
            if naviVC.tabBarItem.title == "U业帮" {
                if UYAPPManager.shared.userInfo == nil {
                    let loginVC = UYLoginViewController()
                    loginVC.loginSuccess {
                        tabBarController.selectedIndex = 1;
                    }
                    let oryNavi = tabBarController.selectedViewController as! UYNavigationController
                    oryNavi.pushViewController(loginVC, animated: true)
                    return false
                }
            }
        }
        return true
    }
    
}

