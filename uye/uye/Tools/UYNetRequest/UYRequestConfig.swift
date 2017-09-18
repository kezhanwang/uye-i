//
//  UYRequestConfig.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import Alamofire

class UYRequestConfig: NSObject {
    var requestMethod : HTTPMethod = .post
    var requestURL : UYRequestAPI?
    var parameters : Parameters?
}
// MARK: - 网络请求的API
enum UYRequestAPI : String {
    case login = "app/appuser/uinfo"
    
    
    func requestURLString(baseURL : String) -> String {
        return "\(baseURL)\(self.rawValue)"
    }
}
