//
//  UYAPPManager.swift
//  uye
//
//  Created by Tintin on 2017/10/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit


class UYAPPManager: NSObject {
    var userInfo :UYUserInfo?
    
    /// 以下是单例的一种写法
    static let shared = UYAPPManager()
    /// 将init方法私有化了,这样在其他地方就无法init
    private override init() {
        super.init()
        if let userJson = NSKeyedUnarchiver.unarchiveObject(withFile:documentPath("user")) as? [String :Any] {
            self.userInfo = UYUserInfo.deserialize(from: userJson)
        }
    }
    func loginSuccess(userInfo:UYUserInfo) {
        self.userInfo = userInfo
        NSKeyedArchiver.archiveRootObject(self.userInfo?.toJSON() ?? [String :Any](), toFile:documentPath("user"))
        setHttpCookie()
    }
    func logoutAction() {
        self.userInfo = nil
        removeHttpCookie()
    }
}

// MARK: - Cookie 的处理
extension UYAPPManager {
    func setHttpCookie() {
        let properties :[HTTPCookiePropertyKey : Any] = [HTTPCookiePropertyKey.name:"b42e7_uye_user",
                                                         HTTPCookiePropertyKey.value:userInfo!.cookie!.b42e7_uye_user!]
        
        let httpCookie :HTTPCookie = HTTPCookie(properties: properties)!
        HTTPCookieStorage.shared.setCookie(httpCookie)
        
    }
    func removeHttpCookie() {
        let cookies = HTTPCookieStorage.shared.cookies
        for cookie in cookies! {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }
}

fileprivate  func documentPath(_ name:String) -> String {
    return  NSHomeDirectory().appending("/Documents/\(name).data")
}
