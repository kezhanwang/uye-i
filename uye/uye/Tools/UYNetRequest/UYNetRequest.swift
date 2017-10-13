//
//  UYNetRequest.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit


/// 网络请求的类
class UYNetRequest: NSObject {
    var page : Int = 1
    
}
// MARK: - 公共部分
extension UYNetRequest {
    // MARK: 获取短信验证码
    func getPhoneCodeLoginRequest(phone:String,complete:@escaping(_ error:Error?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.SMScode
        config.requestMethod = .get
        config.parameters = ["phone":phone]
        UYRequestManager.shared.request(config: config, type: UYHomeModel.self) { (homeModel: Any, error:Error?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete(nil)
            }
        }
    }
 
}
// MARK: - 登录注册相关
extension UYNetRequest {
    // MARK: 注册
    func registerRequest(phone:String,code:String,pwd:String, complete:@escaping(_ userInfo:UYUserInfo?,_ error:Error?) -> (Void))  {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.register
        config.requestMethod = .get
        config.parameters = ["phone":phone,
                             "code":code,
                             "password":pwd]
        UYRequestManager.shared.request(config: config, type: UYHomeModel.self) { (homeModel: Any, error:Error?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((homeModel as! UYUserInfo),nil)
            }
        }
    }
     // MARK: 密码登录
    func passwordLoginRequest(phone:String,pwd:String,complete:@escaping(_ userInfo:UYUserInfo?,_ error:Error?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.login
        config.requestMethod = .get
        config.parameters = ["phone":phone,
                             "password":pwd]
        UYRequestManager.shared.request(config: config, type: UYHomeModel.self) { (homeModel: Any, error:Error?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((homeModel as! UYUserInfo),nil)
            }
        }
    }
     // MARK: 验证码登录
    func phoneCodeLoginRequest(phone:String,code:String,complete:@escaping(_ userInfo:UYUserInfo?,_ error:Error?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.loginWithCode
        config.requestMethod = .get
        config.parameters = ["phone":phone,
                             "code":code]
        UYRequestManager.shared.request(config: config, type: UYHomeModel.self) { (homeModel: Any, error:Error?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((homeModel as! UYUserInfo),nil)
            }
        }
    }
  
    
}

// MARK: - 首页相关
extension UYNetRequest {
// MARK: 首页获取分类
    func getHomeCategorysData(complete:@escaping(_ result:UYHomeModel?,_ error:Error?) -> Void) {
        
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.categorys
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYHomeModel.self) { (homeModel: Any, error:Error?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((homeModel as! UYHomeModel),nil)
            }
        }
    }
}

// MARK: - 机构课程相关
extension UYNetRequest {
  
    // MARK: 首页机构推荐列表和搜索的列表。
    func getOrganiseList(isRefash:Bool,word:String = "location", complete:@escaping(_ result:UYOrganiseList?,_ error:Error?) ->(Void)) {
        
        if isRefash {
            page = 1;
        }
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.organise
        config.requestMethod = .get
        
        config.parameters = ["word":word,
                             "page":page]
        
        UYRequestManager.shared.request(config: config, type: UYOrganiseList.self) { (list:Any, error:Error?) in
            if error != nil {
                complete(nil,error)
            }else{
                self.page += 1;
                complete((list as! UYOrganiseList),nil)
            }
        }
    }
}

// MARK: - 我的相关
extension UYNetRequest {
    
}


