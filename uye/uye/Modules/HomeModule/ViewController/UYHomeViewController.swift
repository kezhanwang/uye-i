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
        
        if UYLocationManager.shared.allowLocationAuthorization {
            updateLocation()
        }else{
            UYLocationManager.shared.loactionAuthorizationStatusChanged {[weak self] in
                self?.updateLocation()
            }
        }
    
        buton.setTitle("去搜索看", for: UIControlState.normal)
        view.addSubview(buton)
        buton.addTarget(self, action: #selector(showAToast), for: UIControlEvents.touchUpInside)
        buton.backgroundColor = UIColor.randomColor
        buton.snp.makeConstraints { (make) in
            make.top.left.equalTo(100)
            make.width.height.equalTo(80)
        }
    }
    @objc func showAToast() {
        pushToNextVC(nextVC: UYSearchViewController())
    }
}

// MARK: - 获取数据
extension UYHomeViewController {
    func updateLocation() {
        UYLocationManager.shared.beginUpdataLocation(complete: {[weak self] (success) -> (Void) in
            self?.getHomeData()
        })
    }
    func getHomeData() {
        showWaitToast()
        request.getHomeCategorysData {[weak self] (data:UYHomeModel?, error : UYError?) in
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.showTextToastAutoDismiss(msg: "(error?.description)!")

            }
        }
        

        
        
        
    }
}

