//
//  UYRequestConfig.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

let UYURLTypeKey = "com.kezhan.base.URL.type"
let DistributionURL = "http://dev.bjzhongteng.com/"
let DevelopmentURL = "http://dev.bjzhongteng.com/"

enum UYDevelopPlatform : Int {
    case Distribution = 0
    case UAT = 1
    case Development = 2
    case Test = 3
}

class UYRequestConfig: NSObject {
    var requestMethod : HTTPMethod = .post
    var requestURL : UYRequestAPI?
    var parameters : Parameters?

    var images : [UYImageModel]?
    
}

// MARK: - 网络请求的API
//htt//dev.bjzhongteng.com/app/index/index?lng=113.305791&lat=23.337532
enum UYRequestAPI : String {
    //公共部分
    case SMScode = "safe/getmsgcode" //获取短信验证码
    case commonProvince = "common/province" //获取省列表
    case commonCity = "common/city" //获取城市列表
    case commonArea = "common/area" //获取区域列表
    case common400 = "common/get400" //获取400电话
    case commonUpload = "common/upload" //上传图片
    case commonVersion = "app/config/version"//版本升级检查
    case udcredit = "udcredit/index"//有盾云的配置信息
    case udcreditPic = "app/identity/pic"//有盾云识别后，获取身份证的照片
    ///账号相关
    case login = "login/login" //登录
    case register = "login/register"//注册
    case loginWithCode = "login/Loginphone" //短信验证码登录
    case logout = "login/logout" //退出登录
    //首页机构相关
    case homeIndex = "app/index/index" //首页分类接口
    case organise = "app/index/inquire"//首页附近机构推荐（分页）和机构搜索接口
    case searchHistory = "app/index/search" //搜索历史以及热门
    case organizationDetail = "app/index/org"//机构详情
    case organizeIntroduce = "app/org/view" //机构简介webView
    //分期相关
    case applyQuestionList = "app/question/config" //申请之问卷调查列表
    case applyQuestionSubmit = "app/question/submit" ////申请之问卷调查提交
    
    case userInfoStatus = "app/user/index" //用户信息的各项状态
    
    case userInfoConfig = "app/identity/config" //用户信息绑定的配置
    case userIdentifyInfo = "app/identity/info" //用户身份信息获取
    case userIdentifySubmit = "app/identity/submit" //用户信息绑定提交
    
    case userContactConfig = "app/contact/config"//联系人信息的配置：婚姻状态，关系列表
    case userContactInfo = "app/contact/info"//联系人信息
    case userContactSubmit = "app/contact/submit"//联系人信息提交
    
    case userExperConfig = "app/exper/config" //获取个人经历的配置（包含添加学历的配置）
    case userExperInfo = "app/exper/info" //获取个人经历的信息
    case userExperSubmit = "app/exper/submit"
    
    
    case userMobileSubmit = "app/mobile/submit" //用户手机通讯录提交
    
    case orderOrganizeInfo = "app/insured/config" //订单的机构信息
    case orderSubmit = "app/insured/submit" //订单提交
    
    //订单信息
    case orderList = "app/order/list"//订单列表
    
    
    func requestURLString() -> String {
        return baseURL() + self.rawValue
    }
}
func organiseIntroduce(orgId:String) -> String {
    return "\(UYRequestAPI.organizeIntroduce.requestURLString())?org_id=\(orgId)"
}

func baseURL() -> String {
    let urlType : UYDevelopPlatform = UYDevelopPlatform(rawValue: UserDefaults.standard.integer(forKey: UYURLTypeKey))!
    switch urlType {
    case .Distribution:
        return DevelopmentURL
    case _ :
        return DistributionURL
    }
}
func updateDevelopPlatform(devPlatform:UYDevelopPlatform) {
    UserDefaults.standard.set(devPlatform, forKey: UYURLTypeKey)
    UserDefaults.standard.synchronize()
}
