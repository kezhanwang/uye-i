//
//  UYNavigationController.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYNavigationController: UINavigationController {
    var canSlidingBack :Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        interactivePopGestureRecognizer?.delegate = self;
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if viewController.isKind(of: UYBaseViewController.self) {
                let targetVC = viewController as! UYBaseViewController
                targetVC.navigationItem.leftBarButtonItem = UIBarButtonItem.backBarButton(target: self, action: #selector(popBackAction))
//                targetVC.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", target: self, action: #selector(popBackAction), isBack: true)
                
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc private func popBackAction() {
        canSlidingBack = true
        popViewController(animated: true)
    }
}
extension UYNavigationController :UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count > 0 && canSlidingBack == true  {
            return true
        }
        return false
    }
}
extension UYNavigationController {
    func setupNavigationBar()  {

        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor.navigationBarTintColor
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.navigationBarTintColor,
                                             NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)];
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.navigationBarTintColor,
                                                             NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], for: UIControlState.normal)
    }

}
