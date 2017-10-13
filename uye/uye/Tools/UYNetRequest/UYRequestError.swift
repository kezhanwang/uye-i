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
