//
//  UYImageModel.swift
//  uye
//
//  Created by Tintin on 2017/10/22.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit


/// 要上传的图片 和多图上传完成待上传额
struct UYImageModel {
    
    var name :String?
    var data :Data?
    
    
    
    
    
    
    init(name aName:String,data aData:Data) {
        name = aName
        data = aData
    }
}
