//
//  UYNavigationController.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if viewController.isKind(of: UYBaseViewController.self) {
                let targetVC = viewController as! UYBaseViewController
                targetVC.navigationItemKZ.leftBarButtonItem = UIBarButtonItem.init(title: "", target: self, action: #selector(popBackAction), isBack: true)
            }
            
        }
        super.pushViewController(viewController, animated: animated)
    }
    @objc private func popBackAction() {
        popViewController(animated: true)
    }



}
