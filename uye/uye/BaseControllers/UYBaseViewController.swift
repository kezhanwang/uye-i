//
//  UYBaseViewController.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
class UYBaseViewController: UIViewController {
    lazy var request : UYNetRequest = {
        () -> UYNetRequest in
        return UYNetRequest()
    }()
    lazy var errorView :UIView = {
         () -> UIView in
        return UIView()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        if #available(iOS 11.0, *) {
            
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupUI()
    }
 
    deinit {
        print("\(self)释放啦")
    }
    open func setupUI(){
    }
}
extension UYBaseViewController {
    func setupErrorView(image:String,title:String) {
        if view.subviews.contains(errorView) {
            view.bringSubview(toFront: errorView)
            return
        }else{
            view.addSubview(errorView)
        }
        errorView.backgroundColor = UIColor.white
        for subView in errorView.subviews {
            subView.removeFromSuperview()
        }
        
        let imageView = UIImageView()
        let titleLabel = UILabel()
        errorView.addSubview(imageView)
        errorView.addSubview(titleLabel)
        imageView.image = UIImage(named: image)
        titleLabel.text = title
        titleLabel.textColor = UIColor.grayText
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = NSTextAlignment.center
        errorView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(errorView)
            make.centerY.equalTo(errorView.snp.centerY).offset(-40)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(errorView)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        view.bringSubview(toFront: errorView)
        
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
    func popToRootViewController(after:DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: after) {
           self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func popToViewController(targetVC :UIViewController) {
        navigationController?.popToViewController(targetVC, animated: true)
    }
}
