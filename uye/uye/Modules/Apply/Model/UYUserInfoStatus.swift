//
//  UYUserInfoStatus.swift
//  uye
//
//  Created by Tintin on 2017/10/20.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYUserInfoStatus: UYBaseModel {
    var identity :Bool = false
    
}

class UYBankInfo:UYBaseModel {
    var open_bank_code:String?
    var open_bank:String?
    var icon:String?
    var isSelected:Bool = false
    
    
}
class UYUDCreditCongig: UYBaseModel {
    var key:String?
    var order:String?
    var user_id:String?
    var notify_url:String?
    var safe_mode:String?
    
}
class UYUDCreditUserPic: UYBaseModel {
    var id_card_info_pic:String?
    var id_card_nation_pic:String?

}

