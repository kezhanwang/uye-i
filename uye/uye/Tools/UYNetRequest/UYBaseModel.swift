//
//  UYBaseModel.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import Foundation

import HandyJSON

class UYBaseModel: HandyJSON {
    required init() {}
    
    func mapping(mapper: HelpingMapper) {}
}

class UYResponseModel<T:HandyJSON>: UYBaseModel {
    var code : Int?
    var data :T? //数组或者字典
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


