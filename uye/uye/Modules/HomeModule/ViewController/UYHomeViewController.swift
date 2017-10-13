//
//  UYHomeViewController.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYHomeViewController: UYBaseViewController {
    
    
    fileprivate let buton = UIButton(type: UIButtonType.system)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        
        
        buton.setTitle("点击看看", for: UIControlState.normal)
        view.addSubview(buton)
        buton.addTarget(self, action: #selector(showToast), for: UIControlEvents.touchUpInside)
        buton.backgroundColor = UIColor.randomColor()
        buton.snp.makeConstraints { (make) in
            make.top.left.equalTo(100)
            make.width.height.equalTo(80)
        }
    }
    @objc func showToast() {
        getHomeData()
    }
}

// MARK: - 获取数据
extension UYHomeViewController {
    func getHomeData() {
        showWaitToast()
        request.getHomeCategorysData { (data:UYHomeModel?, error : Error?) in
            self.dismissAllToast()
            if error != nil {
                self.showTextToastAutoDismiss(msg: (error?.localizedDescription)!)
            }else{

            }
        }
        
//        request.getOrganiseList(isRefash: true, word: "上海") { (list:UYOrganiseList?, error:Error?) -> (Void) in
//            self.dismissAllToast()
//            if error != nil {
//                self.showTextToastAutoDismiss(msg: (error?.localizedDescription)!)
//            }else{
//
//            }
//        }
        
        
        
    }
}

