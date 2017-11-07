//
//  UYBaseActionSheetView.swift
//  uye
//
//  Created by Tintin on 2017/11/6.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYBaseActionSheetView: UIView {
    
    override init(frame: CGRect) {
        let aframe = CGRect(x: kScreenWidth, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight)
        super.init(frame: aframe)
      
        let tapGets = UITapGestureRecognizer(target: self, action: #selector(dismissActionSheet))
        addGestureRecognizer(tapGets)
        backgroundColor = UIColor(white: 0, alpha: 0.4)        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showActionSheet() {
        let keyWindow = UIApplication.shared.keyWindow
        alpha = 0
        keyWindow?.addSubview(self)
        snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(kScreenHeight)
            make.bottom.equalTo(kScreenHeight)
        }
        layoutIfNeeded()
        snp.updateConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
            self.layoutIfNeeded()
        }
    }
    @objc func dismissActionSheet()  {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (isFinish) in
            if isFinish {
                self.removeFromSuperview()
            }
        }
    }
}
