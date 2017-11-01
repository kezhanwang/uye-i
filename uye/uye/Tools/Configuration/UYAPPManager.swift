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
    
    var questionListInfo :UYQuestionList?
    
    fileprivate var request = UYNetRequest()
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
        deletePath("user")
        removeHttpCookie()
    }
    
    func checkAPPVersion()  {
        request.checkVersionRequest { (versionInfo, error) -> (Void) in
            if error == nil {
                if versionInfo?.isUpdate == true {
                    let tabBC :UYTabBarController = UIApplication.shared.keyWindow?.rootViewController as! UYTabBarController
                    tabBC.showAppVersionUpdateAlert(version: versionInfo!)
                }
            }
        }
    }
    
    func checkOrganiseNeedQuestion(orgId:String, complete:@escaping ()->(Void)) {
        request.getQuestionListRequest(orgId: orgId) { (quesList, error) in
            if error != nil {
                SRToast.shared.showTextToastAutoDismiss(msg: (error?.description)!)
            }else{
                self.questionListInfo = quesList!
            }
            complete()
        }
    }
    
}

// MARK: - Cookie 的处理
extension UYAPPManager {
    func setHttpCookie() {
        NotificationCenter.default.post(name: LoginStatusChange, object: nil)
        let hoursToAddInSeconds: TimeInterval = 2629743*12
        let expiresDate = NSDate().addingTimeInterval(hoursToAddInSeconds)
        
        let properties1 :[HTTPCookiePropertyKey : Any] = [HTTPCookiePropertyKey.name:"b42e7_uye_user",
                                                         HTTPCookiePropertyKey.value:userInfo!.cookie!.b42e7_uye_user!,
                                                         HTTPCookiePropertyKey.path:"/",
                                                         HTTPCookiePropertyKey.domain:".bjzhongteng.com",
                                                         HTTPCookiePropertyKey.expires:expiresDate,
                                                         ]
        let properties2 :[HTTPCookiePropertyKey : Any] = [HTTPCookiePropertyKey.name:"PHPSESSID",
                                                          HTTPCookiePropertyKey.value:userInfo!.cookie!.PHPSESSID!,
                                                         HTTPCookiePropertyKey.path:"/",
                                                         HTTPCookiePropertyKey.domain:".bjzhongteng.com",
                                                         HTTPCookiePropertyKey.expires:expiresDate]
       
        let httpCookie1 :HTTPCookie = HTTPCookie(properties: properties1)!
        HTTPCookieStorage.shared.setCookie(httpCookie1)
        
        let httpCookie2 :HTTPCookie = HTTPCookie(properties:properties2)!
        HTTPCookieStorage.shared.setCookie(httpCookie2)
        
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
fileprivate func deletePath(_ name:String) {
    try? FileManager.default.removeItem(atPath: documentPath(name))
}
