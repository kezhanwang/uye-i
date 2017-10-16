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
}

// MARK: - 网络请求的API
//htt//dev.bjzhongteng.com/app/index/index?lng=113.305791&lat=23.337532
enum UYRequestAPI : String {
    ///账号相关
    case login = "login/login" //登录
    case register = "login/register"//注册
    case loginWithCode = "login/Loginphone" //短信验证码登录
    case SMScode = "safe/getmsgcode" //获取短信验证码
    
    //首页机构相关
    case categorys = "app/index/index" //首页分类接口
    case organise = "app/index/inquire"//首页附近机构推荐（分页）和机构搜索接口
    case searchHistory = "app/index/search" //搜索历史以及热门
    case organizationDetail = "app/index/org"//机构详情
    
    func requestURLString() -> String {
        return baseURL() + self.rawValue
    }
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
