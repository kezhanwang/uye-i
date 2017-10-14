//
//  UYTableFooterView.swift
//  uye
//
//  Created by Tintin on 2017/10/14.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYTableFooterView: UIView {
    
    fileprivate var footerBtn = UIButton(type: UIButtonType.custom)
    weak var delegate : UYTableFooterViewDelegate?
    var enable:Bool = true {
        didSet {
            footerBtn.isEnabled = enable
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(footerBtn)
        footerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(37)
            make.height.equalTo(49)
        }
        footerBtn.setBackgroundImage(UIImage.imageColor(color: UIColor.themeColor), for: UIControlState.normal)
        footerBtn.layer.cornerRadius = 8
        footerBtn.layer.masksToBounds = true
        footerBtn.addTarget(self, action: #selector(footerBtnAction), for: UIControlEvents.touchUpInside)
    }
    convenience init(title:String = "",frame:CGRect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 100)) {
        self.init(frame: frame)
        footerBtn.setTitle(title, for: UIControlState.normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func footerBtnAction() {
        if delegate != nil {
            delegate!.footButtonAction()
        }
    }
    
}
protocol UYTableFooterViewDelegate :NSObjectProtocol {
    func footButtonAction()
}
