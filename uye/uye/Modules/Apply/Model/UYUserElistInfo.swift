//
//  UYUserElistInfo.swift
//  uye
//
//  Created by Tintin on 2017/10/31.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
class UYUserElistListData: UYBaseModel {
    var list:[UYUserElistInfo]?
    
}
//学历以及职业的model
class UYUserElistInfo: UYBaseModel {
    var uid:String?
    //学历或职业的id
    var id:String?
    
    var date_start:String?//工作/上学开始时间
    var date_end:String?//结束时间
    
    var work_name:String?//工作单位名称
    var work_position:String?//工作职位
    var work_salary:String?//工作薪资
    
    var education:String?//学历
    var school_name:String?//学校名称
    var school_profession:String?//专业名称
    var school_address:String?//地址
    
}
class UYUserElistConfig: UYBaseModel {
    var education = [String]()
    var position = [String]()
    var monthly_income = [String]()
}

