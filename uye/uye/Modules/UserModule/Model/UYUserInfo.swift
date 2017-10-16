//
//  UYUserInfo.swift
//  uye
//
//  Created by Tintin on 2017/10/13.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYUserInfo: UYBaseModel {
    
    var uid:String?
    var username:String?
    var phone:String?
    var status:String?
    var head_protrait:String?
    var cookie:UserCookie?

    
}
class UserCookie: UYBaseModel  {
    
    var PHPSESSID:String?
    var bjzhongteng_com:String?
    var b42e7_uye_user:String?
    
}
