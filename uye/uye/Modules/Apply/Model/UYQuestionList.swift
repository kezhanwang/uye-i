//
//  UYQuestionList.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYQuestionList: UYBaseModel {
    /// 是否需要填写调查问卷，true：需要，false：不需要，直接跳转第二步
    var need_question:Bool?
    var questions:[UYQuestion]?
}

class UYQuestion: UYBaseModel {
    var id:String?
    var question:String?
    
    /// 问题类型，1：单选题，2：多选题
    var type:String?
    var answer:[String]?
    var selectAnswer = Set<String>()
    
}
