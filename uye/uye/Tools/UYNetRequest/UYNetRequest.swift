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
    func getPhoneCodeRequest(phone:String,complete:@escaping(_ error: UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.SMScode
        config.requestMethod = .get
        config.parameters = ["phone":phone]
        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) { (homeModel: Any, error:UYError?) in
            if error != nil {
                complete(error)
            }else{
                complete(nil)
            }
        }
    }
    // MARK: 版本检测
    func checkVersionRequest(complete:@escaping(_ versionInfo:UYVersionInfo?,_ error:UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.commonVersion
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYVersionInfo.self) { (result: Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((result as! UYVersionInfo),error)
            }
        }
        
    }
    // MARK : 上传图片
    func uploadImageRequest(images:[UYImageModel],complete:@escaping(_ picInfo:[String:Any]?,_ error:UYError?) -> (Void))  {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.commonUpload
        config.requestMethod = .get
        config.images = images
        
        showWaitToast()
        UYRequestManager.shared.uploadImageRequest(config: config, uploadProgress: { (progress) in
            showProgressToast(progress: progress)
            
        }) { (picInfo, error) in
            if error != nil {
                complete(nil,error)
                showTextToast(msg: (error?.description)!)
            }else{
                dismissWaitToast()
                complete(picInfo as? [String:Any],nil)
            }
        }
    }
    // MARK: - 获取省列表
    func getProvinceList(complete:@escaping(_ privinces:[UYAddress]?,_ error:UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.commonProvince
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYAddress.self) { (result, error) in
            if error != nil {
                complete(nil,error!)
            }else{
                complete((result as? [UYAddress]),nil)
            }
        }
    }
    func getCityList(province:String,complete:@escaping(_ privinces:[UYAddress]?,_ error:UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.commonCity
        config.requestMethod = .get
        config.parameters = ["province":province]
        UYRequestManager.shared.request(config: config, type: UYAddress.self) { (result, error) in
            if error != nil {
                complete(nil,error!)
            }else{
                complete((result as? [UYAddress]),nil)
            }
        }
    }
    func getAreaList(city:String,complete:@escaping(_ privinces:[UYAddress]?,_ error:UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.commonArea
        config.requestMethod = .get
        config.parameters = ["city":city]
        UYRequestManager.shared.request(config: config, type: UYAddress.self) { (result, error) in
            if error != nil {
                complete(nil,error!)
            }else{
                complete((result as? [UYAddress]),nil)
            }
        }
    }
 
}
// MARK: - 登录注册相关
extension UYNetRequest {
    // MARK: 注册
    func registerRequest(phone:String,code:String,pwd:String, complete:@escaping(_ userInfo:UYUserInfo?,_ error:UYError?) -> (Void))  {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.register
        config.requestMethod = .get
        config.parameters = ["phone":phone,
                             "code":code,
                             "password":pwd]
        UYRequestManager.shared.request(config: config, type: UYUserInfo.self) {[weak self] (userInfo: Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                self?.saveUserInfo(userInf: (userInfo as! UYUserInfo))
                complete((userInfo as! UYUserInfo),nil)
            }
        }
    }
     // MARK: 密码登录
    func loginWithPasswordRequest(phone:String,pwd:String,complete:@escaping(_ userInfo:UYUserInfo?,_ error:UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.login
        config.requestMethod = .get
        config.parameters = ["phone":phone,
                             "password":pwd]
        UYRequestManager.shared.request(config: config, type: UYUserInfo.self) {[weak self] (userInfo: Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                self?.saveUserInfo(userInf: (userInfo as! UYUserInfo))
                complete((userInfo as! UYUserInfo),nil)
            }
        }
    }
     // MARK: 验证码登录
    func loginWithPhoneCodeRequest(phone:String,code:String,complete:@escaping(_ userInfo:UYUserInfo?,_ error:UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.loginWithCode
        config.requestMethod = .get
        config.parameters = ["phone":phone,
                             "code":code]
        UYRequestManager.shared.request(config: config, type: UYUserInfo.self) {[weak self] (userInfo: Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                self?.saveUserInfo(userInf: (userInfo as! UYUserInfo))
                complete((userInfo as! UYUserInfo),nil)
            }
        }
    }
    func saveUserInfo(userInf:UYUserInfo) {
        UYAPPManager.shared.loginSuccess(userInfo: userInf)
    }
    
    func logoutAction(complete:@escaping(_ error: UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.logout
        config.requestMethod = .get

        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) {(empty: Any, error:UYError?) in
            if error != nil {
                complete(error)
            }else{
                UYAPPManager.shared.logoutAction()
                complete(nil)
            }
        }
    }
  
    
}

// MARK: - 首页相关
extension UYNetRequest {
    // MARK: 首页获取
    func getHomeData(complete:@escaping(_ result:UYHomeModel?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.homeIndex
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYHomeModel.self) { (homeModel: Any, error:UYError?) in
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
    func getOrganiseList(isRefash:Bool,word:String = "location", complete:@escaping(_ result:UYOrganiseList?,_ error:UYError?) ->(Void)) {
        
        if isRefash {
            page = 1;
        }
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.organise
        config.requestMethod = .get
        
        config.parameters = ["word":word,
                             "page":page]
        
        UYRequestManager.shared.request(config: config, type: UYOrganiseList.self) { (list:Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                self.page += 1;
                complete((list as! UYOrganiseList),nil)
            }
        }
    }
    // MARK: 获取热门搜索以及搜索历史
    func getSearchDataRequest(complete:@escaping(_ result:UYSearchModel?,_ error:UYError?) -> Void) {
        
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.searchHistory
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYSearchModel.self) { (list:Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYSearchModel),error)
            }
        }
    }
    func getOrganiseDetail(orgId:String, complete:@escaping(_ result:UYOrganiseDetailModel?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.organizationDetail
        config.requestMethod = .get
        config.parameters = ["org_id":orgId]
        UYRequestManager.shared.request(config: config, type: UYOrganiseDetailModel.self) { (list:Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYOrganiseDetailModel),error)
            }
        }
    }
  

}


// MARK: - 申请相关之问卷调查
extension UYNetRequest {
    func getQuestionListRequest(orgId:String, complete:@escaping(_ result:UYQuestionList?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.applyQuestionList
        config.requestMethod = .get
        config.parameters = ["org_id":orgId]
        UYRequestManager.shared.request(config: config, type: UYQuestionList.self) { (list:Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYQuestionList),error)
            }
        }
    }
    func submitQuestionAnswer(orgId:String,answers:String,complete:@escaping(_ error: UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.applyQuestionSubmit
        config.requestMethod = .post
        config.parameters = ["org_id":orgId,
                             "question":answers]
        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) { (list:Any, error:UYError?) in
            complete(error)
        }
    }
    
}

// MARK: - 申请相关之用户信息
extension UYNetRequest {
    
    func getUsetInfoStatus(complete:@escaping(_ result:UYUserInfoStatus?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userInfoStatus
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYUserInfoStatus.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYUserInfoStatus),error)
            }
        }
    }
    func getUserInfoConfig(complete:@escaping(_ result:[UYBankInfo]?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userInfoConfig
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYBankInfo.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! [UYBankInfo]),error)
            }
        }
    }
    func getUserUDCreditRequest(complete:@escaping(_ result:UYUDCreditCongig?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.udcredit
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYUDCreditCongig.self) { (result:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((result as! UYUDCreditCongig),error)
            }
        }
    }
    
    func getUserUDCreditUserPic(udcredit_order:String, complete:@escaping(_ result:UYUDCreditUserPic?,_ error:UYError?) -> Void) {
        
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.udcreditPic
        config.requestMethod = .get
        config.parameters = ["udcredit_order":udcredit_order]
        UYRequestManager.shared.request(config: config, type: UYUDCreditUserPic.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYUDCreditUserPic),error)
            }
        }
    }
    func getUserInfoRequest(complete:@escaping(_ result:UYUserInfo?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userIdentifyInfo
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYUserInfo.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYUserInfo),error)
            }
        }
    }
    
    func submitUserInfo(parameters:[String:Any],complete:@escaping(_ error: UYError?) -> (Void)) {

        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userIdentifySubmit
        config.requestMethod = .get
        config.parameters = parameters
        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) { (result:Any, error) in
            complete(error)
        }
    }
    func submitUserMobileBook(parameters:[String:Any],complete:@escaping(_ error: UYError?) -> (Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userMobileSubmit
        config.requestMethod = .post
        config.parameters = parameters
        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) { (result:Any, error) in
            complete(error)
        }
    }
}

// MARK: - 申请相关之联系人信息
extension UYNetRequest {
    func getUserContactConfig(complete:@escaping(_ result:UYContactConfig?,_ error:UYError?) -> Void) {

        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userContactConfig
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYContactConfig.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYContactConfig),error)
            }
        }
    }
    func getUserContactInfo(complete:@escaping(_ result:UYUserContactInfo?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userContactInfo
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYUserContactInfo.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYUserContactInfo),error)
            }
        }
    }
    func submitUserContactInfo(parameters:[String:Any],complete:@escaping(_ error: UYError?) -> (Void)) {

        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userContactSubmit
        config.requestMethod = .post
        config.parameters = parameters
        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) { (result:Any, error) in
            complete(error)
        }
    }
}

// MARK: - 申请相关之个人经历
extension UYNetRequest {
    func getUserExperConfig(complete:@escaping(_ result:UYUserExperConfig?,_ error:UYError?) -> Void) {
        
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userExperConfig
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYUserExperConfig.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYUserExperConfig),error)
            }
        }
    }
    func getUserExperInfo(complete:@escaping(_ result:UYUserExperInfo?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userExperInfo
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYUserExperInfo.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYUserExperInfo),error)
            }
        }
    }
    func submitUserExperInfo(parameters:[String:Any],complete:@escaping(_ error: UYError?) -> (Void)) {
        
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userExperSubmit
        config.requestMethod = .post
        config.parameters = parameters
        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) { (result:Any, error) in
            complete(error)
        }
    }
}

// MARK: - 申请相关个人经历之职业以及学历
extension UYNetRequest {
    func getUserElistConfig(complete:@escaping(_ result:UYUserElistConfig?,_ error:UYError?) -> Void) {
        
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userElistConfig
        config.requestMethod = .get
        UYRequestManager.shared.request(config: config, type: UYUserElistConfig.self) { (list:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYUserElistConfig),error)
            }
        }
    }
    func getUserElistInfo(type:Int, complete:@escaping(_ result:[UYUserElistInfo]?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userElistInfo
        config.requestMethod = .get
        config.parameters = ["type":type]
        UYRequestManager.shared.request(config: config, type: UYUserElistListData.self) { (result:Any, error) in
            if error != nil {
                complete(nil,error)
            }else{
                let infos = result as! UYUserElistListData
                complete(infos.list,error)
            }
        }
    }
    func submitUserElistInfo(parameters:[String:Any],complete:@escaping(_ error: UYError?) -> (Void)) {
        
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userElistSubmit
        config.requestMethod = .post
        config.parameters = parameters
        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) { (result:Any, error) in
            complete(error)
        }
    }
    func deleteUserElist(elistId:String, complete:@escaping(_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.userElistDelete
        config.requestMethod = .get
        config.parameters = ["id":elistId]
        UYRequestManager.shared.request(config: config, type: UYUserElistInfo.self) { (list:Any, error) in
            complete(error)
        }
    }
}
// MARK: - 申请相关之机构订单
extension UYNetRequest {
    func getOrderOrganiseConfig(orgId:String, complete:@escaping(_ result:UYOrganiseConfig?,_ error:UYError?) -> Void) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.orderOrganizeInfo
        config.requestMethod = .get
        config.parameters = ["org_id":orgId]
        UYRequestManager.shared.request(config: config, type: UYOrganiseConfig.self) { (list:Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYOrganiseConfig),error)
            }
        }
    }
    func submitOrderInfo(parameters:[String:Any],complete:@escaping(_ error: UYError?) -> (Void)) {
        
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.orderSubmit
        config.requestMethod = .post
        config.parameters = parameters
        UYRequestManager.shared.request(config: config, type: UYEmptyModel.self) { (result:Any, error) in
            complete(error)
        }
        
    }
}
// MARK: - 订单相关
extension UYNetRequest {
    //UYOrderListModel
    func getOrderList(page:Int, complete:@escaping(_ result:UYOrderListModel?,_ error:UYError?) ->(Void)) {
        let config = UYRequestConfig()
        config.requestURL = UYRequestAPI.orderList
        config.requestMethod = .get
        config.parameters = ["page":page]
        
        UYRequestManager.shared.request(config: config, type: UYOrderListModel.self) { (list:Any, error:UYError?) in
            if error != nil {
                complete(nil,error)
            }else{
                complete((list as! UYOrderListModel),nil)
            }
        }
    }
}

// MARK: - 我的相关
extension UYNetRequest {
    
}


