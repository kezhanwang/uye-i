//
//  UYHomeModel.swift
//  uye
//
//  Created by Tintin on 2017/10/9.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYHomeModel: UYBaseModel {
    var loaction = "北京市"
    var categorys:[UYCategoryModel] = []
    
    
    
}
class UYCategoryModel: UYBaseModel {
    var id = ""
    var name = ""
    var logo = ""
}
