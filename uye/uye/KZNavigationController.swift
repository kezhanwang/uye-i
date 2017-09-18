//
//  KZNavigationController.swift
//  kezhan
//
//  Created by Tintin on 2017/5/2.
//  Copyright © 2017 KeZhan. All rights reserved.
//

import UIKit

class KZNavigationController: UINavigationController ,UIGestureRecognizerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if viewController.isKind(of: KZBaseViewController.self) {
                let targetVC = viewController as! KZBaseViewController
                targetVC.navigationItemKZ.leftBarButtonItem = UIBarButtonItem(title: "", target: self, action: #selector(popBackAction), isBack: true)
            }
            
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc private func popBackAction() {
        popViewController(animated: true)
    }    
}
