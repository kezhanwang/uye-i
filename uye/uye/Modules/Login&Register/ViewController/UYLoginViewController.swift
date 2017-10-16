//
//  UYLoginViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/14.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYLoginViewController: UYBaseViewController {

    fileprivate let phoneTextField = UITextField()
    fileprivate let codeTextField = UITextField()
    fileprivate let getCodeBtn = UIButton(type: UIButtonType.custom)
    fileprivate let showPwdBtn = UIButton(type: UIButtonType.custom)
    fileprivate let footerView = UYTableFooterView(title: "登录")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "登录"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", target: self, action: #selector(goRegisterVC))
    }
    
    override func setupUI() {
        addSubeViews()
        
        phoneTextField.placeholder = "手机号"
        phoneTextField.font = UIFont.systemFont(ofSize: 14)
        phoneTextField.textColor = UIColor.blackText
        phoneTextField.delegate = self
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        
        codeTextField.font = UIFont.systemFont(ofSize: 14)
        codeTextField.placeholder = "密码"
        codeTextField.textColor = UIColor.blackText
        codeTextField.delegate = self
        
        getCodeBtn.isHidden = true
        getCodeBtn.isEnabled = false
        getCodeBtn.setTitleColor(UIColor.themeColor, for: UIControlState.normal)
        getCodeBtn.setTitleColor(UIColor.disableTextColor, for: UIControlState.disabled)
        getCodeBtn.setTitle("获取验证码", for: UIControlState.normal)
        getCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        getCodeBtn.addTarget(self, action: #selector(getCodeAction), for: UIControlEvents.touchUpInside)
//        getCodeBtn.backgroundColor = UIColor.randomColor
        
        
        showPwdBtn.setImage(UIImage(named: "code_visible_icon"), for: UIControlState.normal)
        showPwdBtn.setImage(UIImage(named: "code_invisible_icon"), for: UIControlState.selected)
        showPwdBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0)
        showPwdBtn.addTarget(self, action: #selector(showPasswordAction), for: UIControlEvents.touchUpInside)
//        showPwdBtn.backgroundColor = UIColor.randomColor
        
        footerView.delegate = self
        footerView.addLoginSubView()
        
        //初始化一下密文
        showPasswordAction()
        
    }
    
    // MARK: 去注册页面
    @objc func goRegisterVC() {
       pushToNextVC(nextVC: UYRegisterViewController())
    }
    // MARK: 获取手机号验证码
    @objc func getCodeAction(){
        if phoneTextField.text?.lengthOfBytes(using: String.Encoding.utf8) == 11 {
            getCodeBtn.beginCountDown()
        }else{
            showTextToastAutoDismiss(msg: "请输入11位手机号")
        }
    }
    // MARK: 切换密码可见与不可见
    @objc func showPasswordAction() {
        showPwdBtn.isSelected = !showPwdBtn.isSelected
        if showPwdBtn.isSelected {
            codeTextField.isSecureTextEntry = true
        }else{
            codeTextField.isSecureTextEntry = false
        }
    }
}

// MARK: - 设置UI
extension UYLoginViewController  {
    func addSubeViews() {
        view.addSubview(phoneTextField)
        view.addSubview(codeTextField)
        view.addSubview(footerView)
        view.addSubview(getCodeBtn)
        view.addSubview(showPwdBtn)
        
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaHeight)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(49)
        }
        codeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom).offset(0)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(49)
        }
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(codeTextField.snp.bottom).offset(0)
            make.left.right.equalTo(0)
            make.height.equalTo(150)
        }
        getCodeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.top).offset(0)
            make.right.equalTo(-16)
            make.width.equalTo(80)
            make.height.equalTo(49)
        }
        showPwdBtn.snp.makeConstraints { (make) in
            make.top.equalTo(codeTextField.snp.top).offset(0)
            make.right.equalTo(-16)
            make.width.equalTo(50)
            make.height.equalTo(49)
        }
    }
}

// MARK: - 登录按钮。短信、密码登录方式切换按钮
extension UYLoginViewController :UYTableFooterViewDelegate {
    func footButtonAction() {
        if phoneTextField.text!.length != 11 {
            showTextToastAutoDismiss(msg: "请输入11位手机号")
            return
        }
        guard codeTextField.text!.length > 0 else {
            if showPwdBtn.isHidden == true {
                showTextToastAutoDismiss(msg: "请输入短信验证码")
            }else{
                showTextToastAutoDismiss(msg: "请输入密码")
            }
            return
        }
        print("可以登录啦")
    }
    func loginTypeChange(ispwdLogin: Bool) {
        if ispwdLogin {
            showPwdBtn.isHidden = true
            getCodeBtn.isHidden = false
            codeTextField.placeholder = "验证码"
            codeTextField.isSecureTextEntry = false
        }else{
            showPwdBtn.isHidden = false
            getCodeBtn.isHidden = true
            codeTextField.placeholder = "密码"
            codeTextField.isSecureTextEntry = showPwdBtn.isSelected
        }
        codeTextField.text = ""
    }
}

// MARK: - 网络请求
extension UYLoginViewController {
    func getSMSCode() {
        showWaitToast()
        request.getPhoneCodeRequest(phone: phoneTextField.text!) {[weak self] (error:UYError?) -> (Void) in
            if error == nil {
                self?.dismissToast()
                self?.getCodeBtn.beginCountDown()
            }else{
                self?.showTextToastAutoDismiss(msg: error!.description)
            }
        }
    }
    
    /// 根据密码登录
    func loginActionWithPassword() {
        request.loginWithPasswordRequest(phone: phoneTextField.text!, pwd: codeTextField.text!) { (userInf:UYUserInfo?, error:UYError?) -> (Void) in
            
        }
    }
    /// 根据验证码登录
    func loginActionWithSMSCode() {
        request.loginWithPhoneCodeRequest(phone:phoneTextField.text!, code:  codeTextField.text!) { (userInfo, error:UYError?) -> (Void) in
            
        }
    }
}
// MARK: - 设置TextField是否可以输入的条件
extension UYLoginViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if phoneTextField == textField {
            //限制只能输入数字，不能输入特殊字符
            let length = string.lengthOfBytes(using: String.Encoding.utf8)
            for loopIndex in 0 ..< length {
                let char = (string as NSString).character(at: loopIndex)
                if char < 48 {return false }
                if char > 57 {return false }
            }
            //限制长度
            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
            if proposeLength > 11 { return false }
            if proposeLength == 11 && getCodeBtn.isHidden == false {
                getCodeBtn.isEnabled = true
            }else{
                getCodeBtn.isEnabled = false
            }
        }
   
        return true
    }
}
