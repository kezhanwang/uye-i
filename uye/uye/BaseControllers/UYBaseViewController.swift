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
    lazy var request : UYNetRequest = {
        () -> UYNetRequest in
        return UYNetRequest()
    }()
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
    func popBackAction(toRoot:Bool = false) {
        if toRoot {
            navigationController?.popToRootViewController(animated: true)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    func popToViewController(targetVC :UIViewController) {
        navigationController?.popToViewController(targetVC, animated: true)
    }
}
