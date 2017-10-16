//
//  UYRequestError.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import Foundation
import Alamofire


class UYError: NSObject {
    var code : Int = 0
    var msg :String = ""
    init(code aCode:Int = 1000,msg aMsg:String = "请求成功") {
        code = aCode
        
        switch code {
        case -1002:
            msg = "URL不支持"
        case -1009:
            msg = "网络错误"
        default:
            msg = aMsg
        }
    }
    class func mapFailError() -> UYError {
        return UYError(code: -11, msg: "解析失败")
    }
    override var description: String {
        return "\(msg)(\(code))"
    }
    
}

enum UYRequestError: Error {
    case afFail(error:Error)
    case localFail(code:Int, msg:String)
}

extension UYRequestError {
    
    var localizedDescription: String {
        switch self {
        case .afFail(let error):
            return error.localizedDescription;
        case .localFail(let code, let msg):
            return "\(msg)(\(code))"
        }
    }
}

