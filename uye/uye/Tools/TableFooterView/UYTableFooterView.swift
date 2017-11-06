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
        
        var attributedString = NSMutableAttributedString(string: "我已阅读并同意《U业帮用户注册协议》", attributes: multipleAttributes)
        let range = NSRange(location: 7, length: 11)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.greenText, range: range)
        btn.setAttributedTitle(attributedString, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(serviceBtnAction), for: UIControlEvents.touchUpInside)

        return btn
    }()
    
    
    var orderAgreedAgreement:Bool = false
    
    fileprivate lazy var servceAgreeBtn : UIButton = {
        () -> UIButton in
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "agree_btn_normal"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "agree_btn_selected"), for: .selected)
        btn.addTarget(self, action: #selector(agreeSelectBtnAction(agreeBtn:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var orderAgreementBtn :UIButton = {
        () -> UIButton in
        
        let btn = UIButton(type: UIButtonType.custom)
        
        let multipleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.grayText,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        
        var attributedString = NSMutableAttributedString(string: "我已经阅读《U业帮服务协议》并且同意服务条款", attributes: multipleAttributes)
        let range = NSRange(location: 6, length: 7)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.greenText, range: range)
        btn.setAttributedTitle(attributedString, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(orderServiceAgreementAction), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    fileprivate lazy var authoriseAgreeBtn : UIButton = {
        () -> UIButton in
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "agree_btn_normal"), for: .normal)
        btn.setImage(#imageLiteral(resourceName: "agree_btn_selected"), for: .selected)
        btn.addTarget(self, action: #selector(authoriseAgreeBtnAction(agreeBtn:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    fileprivate lazy var authoriseAgreementBtn :UIButton = {
        () -> UIButton in
        
        let btn = UIButton(type: UIButtonType.custom)
        
        let multipleAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.grayText,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        
        var attributedString = NSMutableAttributedString(string: "我已经阅读《U业帮授权协议》并且同意授权", attributes: multipleAttributes)
        let range = NSRange(location: 6, length: 7)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.greenText, range: range)
        btn.setAttributedTitle(attributedString, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(authoriseAgreementBtnAction), for: UIControlEvents.touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(footerBtn)
        footerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.height.equalTo(49)
            make.centerX.equalTo(kScreenWidth/2)
            make.width.equalTo(kScreenWidth-32)
        }
        footerBtn.setBackgroundImage(UIImage.imageColor(color: UIColor.themeColor), for: UIControlState.normal)
        footerBtn.setBackgroundImage(UIImage.imageColor(color: UIColor.disableBackColor), for: UIControlState.disabled)

        footerBtn.layer.cornerRadius = 8
        footerBtn.layer.masksToBounds = true
        footerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        footerBtn.addTarget(self, action: #selector(footerBtnAction), for: UIControlEvents.touchUpInside)
    }
    convenience init(title atitle:String = "",frame:CGRect = CGRect(x: 0, y: 0, width: kScreenWidth, height: 180)) {
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
        serviceBtn.snp.makeConstraints { (make) in
            make.top.equalTo(footerBtn.snp.bottom).offset(10)
            make.left.equalTo(16)
        }
    }
    @objc func serviceBtnAction() {
        if delegate != nil {
            delegate!.registerShowServiceWeb!()
        }
    }
    
}

// MARK: - 订单提交需要的
extension UYTableFooterView {
    func addOrderSubview()  {
        addSubview(servceAgreeBtn)
        addSubview(orderAgreementBtn)
        
        addSubview(authoriseAgreeBtn)
        addSubview(authoriseAgreementBtn)
        
        servceAgreeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(footerBtn.snp.bottom).offset(10)
            make.left.equalTo(16)
            make.width.height.equalTo(30)
        }
        orderAgreementBtn.snp.makeConstraints { (make) in
            make.left.equalTo(servceAgreeBtn.snp.right).offset(10)
            make.centerY.equalTo(servceAgreeBtn.snp.centerY)
        }
        
        authoriseAgreeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(servceAgreeBtn.snp.bottom).offset(5)
            make.left.equalTo(16)
            make.width.height.equalTo(30)
        }
        authoriseAgreementBtn.snp.makeConstraints { (make) in
            make.left.equalTo(authoriseAgreeBtn.snp.right).offset(10)
            make.centerY.equalTo(authoriseAgreeBtn.snp.centerY)
        }
        
        
    }
    
    
    /// 服务协议同意按钮
    @objc func agreeSelectBtnAction(agreeBtn:UIButton) {
        agreeBtn.isSelected = !agreeBtn.isSelected
        if agreeBtn.isSelected && authoriseAgreeBtn.isSelected {
            orderAgreedAgreement = true
        }else{
            orderAgreedAgreement = false
        }
    }
    @objc func orderServiceAgreementAction()  {
        if delegate != nil {
            delegate!.showOrderServiceAgreement!()
        }
    }
    //授权协议同意按钮
    @objc func authoriseAgreeBtnAction(agreeBtn:UIButton) {
        agreeBtn.isSelected = !agreeBtn.isSelected
        if agreeBtn.isSelected && servceAgreeBtn.isSelected {
            orderAgreedAgreement = true
        }else{
            orderAgreedAgreement = false
        }
    }
    @objc func authoriseAgreementBtnAction() {
        if delegate != nil {
            delegate!.showAuthoriseAgreementAction!()
        }
    }
    
}
@objc protocol UYTableFooterViewDelegate :NSObjectProtocol {
    func footButtonAction()
    @objc optional func loginTypeChange(ispwdLogin:Bool)
    
    @objc optional func registerShowServiceWeb()
    
    
    @objc optional func showOrderServiceAgreement()
    @objc optional func showAuthoriseAgreementAction()
}
