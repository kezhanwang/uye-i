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
    var title :String? {
        didSet {
            footerBtn.setTitle(title, for: UIControlState.normal)
        }
    }
    //对内的
    fileprivate let footerBtn = UIButton(type: UIButtonType.custom)
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
    fileprivate lazy var serviceBtn :UIButton = {
        () -> UIButton in
        
        let btn = UIButton(type: UIButtonType.custom)
        let multipleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.grayText,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        
        var attributedString = NSMutableAttributedString(string: "我同意\"服务条款\"和", attributes: multipleAttributes)
        let range = NSRange(location: 4, length: 4)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        btn.setAttributedTitle(attributedString, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(serviceBtnAction), for: UIControlEvents.touchUpInside)

        return btn
    }()
    
    fileprivate lazy var privacyBtn :UIButton = {
        () -> UIButton in
        let btn = UIButton(type: UIButtonType.custom)
        btn.addTarget(self, action: #selector(privacyBtnAction), for: UIControlEvents.touchUpInside)
        
        let multipleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.grayText,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        let attributedString = NSMutableAttributedString(string: "\"隐私权相关政策\"", attributes: multipleAttributes)
        let range = NSRange(location: 1, length: 7)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
        btn .setAttributedTitle(attributedString, for: UIControlState.normal)
        
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(footerBtn)
        footerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(30)
            make.height.equalTo(49)
        }
        footerBtn.setBackgroundImage(UIImage.imageColor(color: UIColor.themeColor), for: UIControlState.normal)
        footerBtn.setBackgroundImage(UIImage.imageColor(color: UIColor.disableBackColor), for: UIControlState.disabled)

        footerBtn.layer.cornerRadius = 8
        footerBtn.layer.masksToBounds = true
        footerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        footerBtn.addTarget(self, action: #selector(footerBtnAction), for: UIControlEvents.touchUpInside)
    }
    convenience init(title atitle:String = "",frame:CGRect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 150)) {
        self.init(frame: frame)
        title = atitle
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

// MARK: - 登录需要的
extension UYTableFooterView {
    /// 登录页面需要的，登录方式切换
    func addLoginSubView(ispwdType:Bool = true) {
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
    @objc func loginTypeChange() {
        loginTypeBtn.isSelected = !loginTypeBtn.isSelected
        if delegate != nil {
            delegate!.loginTypeChange!(ispwdLogin: loginTypeBtn.isSelected)
        }
    }
}

// MARK: - 注册页面需要的
extension UYTableFooterView {
    /// 注册页面需要的，协议展示
    func addRrgisterSubView() {
        addSubview(serviceBtn)
        addSubview(privacyBtn)
        serviceBtn.snp.makeConstraints { (make) in
            make.top.equalTo(footerBtn.snp.bottom).offset(10)
            make.left.equalTo(16)
        }
        privacyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(serviceBtn.snp.top).offset(0)
            make.left.equalTo(serviceBtn.snp.right).offset(0)
        }
    }
    @objc func serviceBtnAction() {
        if delegate != nil {
            delegate!.registerShowServiceWeb!()
        }
    }
    @objc func privacyBtnAction() {
        if delegate != nil {
            delegate!.registerShowPrivacyWeb!()
        }
    }
}
@objc protocol UYTableFooterViewDelegate :NSObjectProtocol {
    func footButtonAction()
    @objc optional func loginTypeChange(ispwdLogin:Bool)
    @objc optional func registerShowServiceWeb()
    @objc optional func registerShowPrivacyWeb()
}
