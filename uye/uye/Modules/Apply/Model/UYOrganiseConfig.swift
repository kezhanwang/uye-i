//
//  UYOrganiseConfig.swift
//  uye
//
//  Created by Tintin on 2017/10/21.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrganiseConfig: UYBaseModel {
    //以下是制作订单返回的机构配置
    var contract:String? //协议
    var organize:UYOrganiseModel? //机构信息
    var courses:[UYCourseModel]?  //课程列表
    
    
}

class UYCourseModel: UYBaseModel {
    var c_id:String?
    var c_name:String?
    
    
}
