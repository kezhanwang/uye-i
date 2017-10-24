//
//  UYHomeModel.swift
//  uye
//
//  Created by Tintin on 2017/10/9.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYHomeModel: UYBaseModel {
    //城市
    var loaction = "北京市"
    //就业帮人数
    var count_order:String?
    var premium_amount_top:Double = 0
    
    var insured_order:UYHomeOrder?
    var organize:UYOrganiseModel?
    var ad_list:[UYAdModle]?
    
}
class UYAdModle: UYBaseModel {
    var logo:String?
    var url:String?
    
    
}
class UYCategoryModel: UYBaseModel {
    var id = ""
    var name = ""
    var logo = ""
}
class UYHomeOrder: UYBaseModel {
    ///赔付金额，单位分，未登录或者已登录但是无订单的返回0
    var compensation:Double = 0
    /// 我的订单数量，未登录或者已登录但是无订单的返回0
    var count:Int = 0
    
    /// 已赔付，单位分，未登录或者已登录但是无订单的返回0
    var paid_compensation:Double = 0
    
    
    
}
