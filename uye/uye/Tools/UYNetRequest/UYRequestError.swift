//
//  UYRequestError.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import Foundation
import Alamofire

public enum UYRequestError: Error {
    case afRequestFail(error:Error)
    case UYResponseFail(code:Int, msg:String)
}

extension UYRequestError {
    var localizedDescription: String {
        switch self {
        case .afRequestFail(let error):
            return error.localizedDescription;
        case .UYResponseFail(let code, let msg):
            return "\(msg)(\(code))"
        }
    }
}
