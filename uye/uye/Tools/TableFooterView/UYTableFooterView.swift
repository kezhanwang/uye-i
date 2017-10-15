//
//  UYTableFooterView.swift
//  uye
//
//  Created by Tintin on 2017/10/14.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYTableFooterView: UIView {
    
    //对外的
    weak var delegate : UYTableFooterViewDelegate?
    var enable:Bool = true {
        didSet {
            footerBtn.isEnabled = enable
        }
    }
    //对内的
    fileprivate var footerBtn = UIButton(type: UIButtonType.custom)
    fileprivate lazy var loginTypeBtn : UIButton = {
        () -> UIButton in
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("使用短信登录", for: UIControlState.normal)
        btn.setTitle("使用密码登录", for: UIControlState.selected)

        btn.setTitleColor(UIColor.blackText, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(loginTypeChange), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
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
        footerBtn.setBackgroundImage(UIImage.imageColor(color: UIColor.disableBackColor), for: UIControlState.disabled)

        footerBtn.layer.cornerRadius = 8
        footerBtn.layer.masksToBounds = true
        footerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        footerBtn.addTarget(self, action: #selector(footerBtnAction), for: UIControlEvents.touchUpInside)
    }
    convenience init(title:String = "",frame:CGRect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 150)) {
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
    @objc func loginTypeChange() {
        loginTypeBtn.isSelected = !loginTypeBtn.isSelected
        if delegate != nil {
            delegate!.loginTypeChange!(ispwdLogin: loginTypeBtn.isSelected)
        }
    }
    @objc func addLoginSubView(ispwdType:Bool = true) {
        addSubview(loginTypeBtn)
        loginTypeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(footerBtn.snp.bottom).offset(10)
            make.right.equalTo(-16)
        }
        if ispwdType {
            loginTypeBtn.setTitle("使用短信登录", for: UIControlState.normal)
        }else{
            loginTypeBtn.setTitle("使用密码登录", for: UIControlState.normal)

        }
    }
}
@objc protocol UYTableFooterViewDelegate :NSObjectProtocol {
    func footButtonAction()
    @objc optional func loginTypeChange(ispwdLogin:Bool)
}
