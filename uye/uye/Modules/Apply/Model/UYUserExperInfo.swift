//
//  UYUserExperInfo.swift
//  uye
//
//  Created by Tintin on 2017/10/31.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit


class UYUserExperConfig: UYBaseModel {
    //学历
    var highest_education:[String]?
    //职业列表
    var profession:[String]?
    //住房性质
    var housing_situation:[String]?
    //月收入
    var monthly_income:[String]?
    
}
class UYUserExperInfo: UYBaseModel {
    var uid:String?//uid
    var highest_education:String?//学历
    var profession:String?//职业
    var monthly_income:String?//月收入
    var housing_situation:String?//住房性质
    var will_work_city = [String]()//期望工作地点
    
}
