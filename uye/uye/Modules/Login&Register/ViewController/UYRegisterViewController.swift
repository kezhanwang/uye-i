//
//  UYRegisterViewController.swift
//  uye
//
//  Created by Tintin on 2017/10/15.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYRegisterViewController: UYBaseViewController {
    fileprivate let phoneTextField = UITextField()
    fileprivate let codeTextField = UITextField()
    fileprivate let pwdTextField = UITextField()
    fileprivate let getCodeBtn = UIButton(type: UIButtonType.custom)
    fileprivate let showPwdBtn = UIButton(type: UIButtonType.custom)
    fileprivate let footerView = UYTableFooterView(title: "立即注册")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "注册"
    }
    override func setupUI() {
        addSubViews()
        configSubViews()
    }

    // MARK: 获取手机号验证码
    @objc func getCodeAction(){
        if phoneTextField.text?.length == 11 {
            getSMSCode()
        }else{
            showTextToastAutoDismiss(msg: "请输入11位手机号")
        }
    }
    // MARK: 切换密码可见与不可见
    @objc func showPasswordAction() {
        showPwdBtn.isSelected = !showPwdBtn.isSelected
        if showPwdBtn.isSelected {
            pwdTextField.isSecureTextEntry = true
        }else{
            pwdTextField.isSecureTextEntry = false
        }
    }
    
}

// MARK: - 设置UI页面
extension UYRegisterViewController {
    func addSubViews() {
        view.addSubview(phoneTextField)
        view.addSubview(codeTextField)
        view.addSubview(pwdTextField)
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
        pwdTextField.snp.makeConstraints { (make) in
            make.top.equalTo(codeTextField.snp.bottom).offset(0)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(49)
        }
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(pwdTextField.snp.bottom).offset(0)
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
            make.top.equalTo(pwdTextField.snp.top).offset(0)
            make.right.equalTo(-16)
            make.width.equalTo(50)
            make.height.equalTo(49)
        }
        
    }
    func configSubViews()  {
        phoneTextField.placeholder = "手机号"
        phoneTextField.font = UIFont.systemFont(ofSize: 14)
        phoneTextField.textColor = UIColor.blackText
        phoneTextField.delegate = self
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        
        codeTextField.font = UIFont.systemFont(ofSize: 14)
        codeTextField.placeholder = "验证码"
        codeTextField.textColor = UIColor.blackText
        codeTextField.delegate = self
        codeTextField.keyboardType = UIKeyboardType.numberPad

        pwdTextField.font = UIFont.systemFont(ofSize: 14)
        pwdTextField.placeholder = "密码"
        pwdTextField.textColor = UIColor.blackText
        pwdTextField.delegate = self
        pwdTextField.isSecureTextEntry = true
        
        getCodeBtn.isEnabled = false
        getCodeBtn.setTitleColor(UIColor.themeColor, for: UIControlState.normal)
        getCodeBtn.setTitleColor(UIColor.disableTextColor, for: UIControlState.disabled)
        getCodeBtn.setTitle("获取验证码", for: UIControlState.normal)
        getCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        getCodeBtn.addTarget(self, action: #selector(getCodeAction), for: UIControlEvents.touchUpInside)
        
        
        showPwdBtn.setImage(UIImage(named: "code_visible_icon"), for: UIControlState.normal)
        showPwdBtn.setImage(UIImage(named: "code_invisible_icon"), for: UIControlState.selected)
        showPwdBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0)
        showPwdBtn.isSelected = true
        showPwdBtn.addTarget(self, action: #selector(showPasswordAction), for: UIControlEvents.touchUpInside)
        
        footerView.delegate = self
        footerView.addRrgisterSubView()
    }
}

// MARK: - 网络请求
extension UYRegisterViewController {
    
    func getSMSCode() {
        showWaitToast()
        request.getPhoneCodeRequest(phone: phoneTextField.text!) {[weak self] (error:UYError?) -> (Void) in
            if error == nil {
                self?.getCodeBtn.beginCountDown()
                self?.dismissToast()
            }else{
                self?.showTextToastAutoDismiss(msg: error!.description)
            }
        }
    }
    
    func checkRegigsterPar() {
        if phoneTextField.text?.length != 11 {
            showTextToastAutoDismiss(msg: "请输入11位手机号")
            return
        }
        guard codeTextField.text!.length > 0 else {
          showTextToastAutoDismiss(msg: "请输入短信验证码")
            return
        }
        guard pwdTextField.text!.length > 0 else {
            showTextToastAutoDismiss(msg: "请输入密码")
            return
        }
        registerAction()
    }
    func registerAction()  {
        showWaitToast()
        request.registerRequest(phone: phoneTextField.text!, code: codeTextField.text!, pwd: pwdTextField.text!) {[weak self] (userInfo, error:UYError?) -> (Void) in
            
            if error != nil {
                self?.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self?.dismissToast()
                self?.popBackAction()
            }
        }
    }
}
extension UYRegisterViewController : UYTableFooterViewDelegate {
    func footButtonAction() {
        checkRegigsterPar()
    }
    
    func registerShowServiceWeb() {
        let webVC = UYWebViewController()
        webVC.urlString = ServiceAgreementURLString
        pushToNextVC(nextVC: webVC)
    }
    
    func registerShowPrivacyWeb() {
        let webVC = UYWebViewController()
        webVC.urlString = PrivacyAgreementURLString
        pushToNextVC(nextVC: webVC)
    }
    
}

extension UYRegisterViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if phoneTextField == textField || codeTextField == textField {
            //限制只能输入数字，不能输入特殊字符
            let length = string.lengthOfBytes(using: String.Encoding.utf8)
            for loopIndex in 0 ..< length {
                let char = (string as NSString).character(at: loopIndex)
                if char < 48 {return false }
                if char > 57 {return false }
            }
            if phoneTextField == textField {
                //限制长度
                let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
                if proposeLength > 11 { return false }
                if proposeLength == 11  {
                    getCodeBtn.isEnabled = true
                }else{
                    getCodeBtn.isEnabled = false
                }
            }
        }
        return true
    }
}
