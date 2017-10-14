//
//  UYBaseViewController.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import SnapKit
class UYBaseViewController: UIViewController {
    let request = UYNetRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        setupUI()
    }
 
    deinit {
        print("\(self)释放啦")
    }
    open func setupUI(){
    }
}

// MARK: - 界面切换的快捷方法
extension UYBaseViewController {
    func pushToNextVC(nextVC :UIViewController) {
        view.endEditing(false)
        navigationController?.pushViewController(nextVC, animated: true)
    }
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
    func popBackAction() {
        navigationController?.popViewController(animated: true)
    }
    func popToViewController(targetVC :UIViewController) {
        navigationController?.popToViewController(targetVC, animated: true)
    }
}
