//
//  UYBaseModel.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import Foundation

import HandyJSON

class UYBaseModel:NSObject, HandyJSON {
    required override init() {
        super.init()
    }
    
    func mapping(mapper: HelpingMapper) {}
}

class UYResponseModel<T:HandyJSON>: UYBaseModel {
    var code : Int?
    var data :T? //数组或者字典
    var msg : String?
    var token :String?
    var timestamp :Double?
    
}
class UYResponseArrayModel<T:HandyJSON>: UYBaseModel {
    var code : Int?
    var data :[T]? //数组或者字典
    var msg : String?
    var token :String?
    var timestamp :Double?
    
}

class UYEmptyModel: UYBaseModel {
    
}


class UYPageModel: UYBaseModel {
    var totalCount : Int = 0
    var totalPage : Int = 0
    var page : Int = 0
    var pageSize : Int = 0
}
class UYVersionInfo: UYBaseModel {
    /// 是否需要更新
    var isUpdate:Bool = false
    ///版本code--Android才需要
    var version_code:String?
    ///版本号
    var version:String?
    ///版本描述
    var desp:String?
    ///下载地址
    var url:String?
    ///创建时间
    var created_time:String?
    ///安装包大小
    var size:String?
    ///是否强制更新
    var forceUpdate:Bool = false
}
class UYComanyPhoneModel: UYBaseModel {
    var company_phone:String?
    
}
