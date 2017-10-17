//
//  UYOrganiseList.swift
//  uye
//
//  Created by Tintin on 2017/10/11.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrganiseList: UYBaseModel {
    var page :UYPageModel?
    var organizes :[UYOrganiseModel]?
}
class UYOrganiseModel: UYBaseModel {
    //机构id
    var org_id:String?
    //机构名称
    var org_name:String?
    //机构联系方式
    var phone:String?
    //机构logo
    var logo:String?
    //距离
    var distance:String?
    
    //机构经纬度
    var map_lat:String?
    var map_lng:String?
    //机构地址
    var address:String?
    //所在省份
    var province:String?
    //所在市
    var city:String?
    //所在区
    var area:String?
    
    var avg_course_price:String?
    //所属分类
    var category:String?
    
    var employment_index:String?
    //是否有就业险业务
    var is_employment:String?
    //是否有高薪险业务
    var is_high_salary:String?
    var is_shelf:String?
    //热门课程
    var popular :String?
    
    var status:String?
    var uye:String?
    
    
}
