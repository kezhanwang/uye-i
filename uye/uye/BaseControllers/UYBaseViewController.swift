//
//  UYBaseViewController.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYBaseViewController: UIViewController {

    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navigationBarHeight))
    lazy var navigationItemKZ = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grayViewColor()
        setupUI()
    }
    override var title: String? {
        didSet {
            navigationItemKZ.title = title
        }
    }
    deinit {
        print("\(self)释放啦")
    }

}
// MARK: - 设置界面
extension UYBaseViewController {
    func setupUI(){
        setupNavigation()
        
    }
    /// 设置添加navigationBar和navigationItemKZ，所有的View都应该在这个View之下
    func setupNavigation() {
        navigationController?.navigationBar.isHidden = true
        view.addSubview(navigationBar)
        navigationBar.barTintColor = UIColor.init(red: 0, green: 165.0/255, blue: 240.0/255, alpha: 1)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 20)];
        navigationBar.items = [navigationItemKZ]
        
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
