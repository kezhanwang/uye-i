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

    
    //以下是用户申请投保的真实信息：
    var full_name:String = ""
    var id_card:String = ""
    var id_card_start:String = ""
    var id_card_end:String = ""
    var id_card_address:String = ""
    var id_card_info_pic:String = "" //人脸面
    var id_card_nation_pic:String = "" //国徽面
    var auth_mobile:String = ""
    var bank_card_number:String = ""
    var open_bank_code:String = ""
    var open_bank:String = ""
    
    
}
class UserCookie: UYBaseModel  {
    
    var PHPSESSID:String?
    var b42e7_uye_user:String?
    
}
