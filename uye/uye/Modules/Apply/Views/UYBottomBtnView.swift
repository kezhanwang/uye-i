//
//  UYBottomBtnView.swift
//  uye
//
//  Created by Tintin on 2017/11/1.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYBottomBtnView: UIView {
    
    weak var delegate:UYTableFooterViewDelegate?
    
    init(title:String) {
        super.init(frame: .zero)
        let bottomBtn = UIButton()
        addSubview(bottomBtn)
        bottomBtn.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(49)
        }
        bottomBtn.setTitle(title, for: UIControlState.normal)
        bottomBtn.addTarget(self, action: #selector(bottomButtonAction), for: .touchUpInside)
        backgroundColor = UIColor.themeColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func bottomButtonAction() {
        if delegate != nil {
            delegate?.footButtonAction()
        }
    }
}

