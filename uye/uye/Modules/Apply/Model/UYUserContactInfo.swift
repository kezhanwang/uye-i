//
//  UYUserContactInfo.swift
//  uye
//
//  Created by Tintin on 2017/10/30.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYUserContactInfo: UYBaseModel {
    
    /// id
    var uid:Int?
    
    var home:String = ""
    
    /// 省id
    var home_province:Int = 0
    
    /// 市id
    var home_city:Int = 0
    
    /// 区id
    var home_area:Int = 0
    
    /// 具体地址
    var home_address:String = ""
    
    /// 邮箱地址
    var email:String = ""
    
    var wechat:String = ""
    
    /// qq号
    var qq:String = ""
    
    /// 婚姻状态
    var marriage:String = ""
    
    /// 联系人姓名
    var contact1_name:String = ""
    
    /// 联系人手机号
    var contact1_phone:String = ""
    
    /// 联系人关系
    var contact1_relation:String = ""
    
    
    
    
    
    
    
}
class UYContactConfig: UYBaseModel {
    var relation:[String]?
    var marriage:[String]?
    
}

