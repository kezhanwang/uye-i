//
//  UYRequestManager.swift
//  uye
//
//  Created by Tintin on 2017/9/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

import Alamofire
import HandyJSON

let UYURLTypeKey = "com.kezhan.base.URL.type"
let DistributionURL = "http://dev.kezhanwang.cn/"
let DevelopmentURL = "http://api2.kezhanwang.cn/"

enum UYDevelopPlatform : Int {
    case Distribution = 0
    case UAT = 1
    case Development = 2
    case Test = 3
}

class UYRequestManager: NSObject {
    var sessionManager : SessionManager?
    
    
    /// 以下是单例的一种写法
    static let shared = UYRequestManager()
    /// 将init方法私有化了,这样在其他地方就无法init
    private override init() {
        super.init()
        configHttpHeaders()
    }
}
// MARK: - 配置所有请求的基本信息
extension UYRequestManager {
    fileprivate func configHttpHeaders()  {
        let defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        sessionManager = Alamofire.SessionManager(configuration:configuration)
    }
    
    
}

// MARK: - 设置基本参数
extension UYRequestManager {
    fileprivate func addBaseParameters(paramete:Parameters?) -> Parameters {
        var par = paramete
        //当前时间的时间戳
        
        par?["_t"] = NSDate().timeIntervalSince1970
        par?["phoneid"] = deviceUUID
        
        return par!
    }
}

// MARK: - URL配置
extension UYRequestManager {
    fileprivate func baseURL() -> String {
        let urlType : UYDevelopPlatform = UYDevelopPlatform(rawValue: UserDefaults.standard.integer(forKey: UYURLTypeKey))!
        switch urlType {
        case .Distribution:
            return DevelopmentURL
        case _ :
            return DistributionURL
        }
    }
    public class func updateDevelopPlatform(devPlatform:UYDevelopPlatform) {
        UserDefaults.standard.set(devPlatform, forKey: UYURLTypeKey)
        UserDefaults.standard.synchronize()
    }
}
// MARK: - Make Requests
extension UYRequestManager {
    
    public func request(config:UYRequestConfig,complete:@escaping(_ result:Array<Any>,_ error:Error?) -> Void) {
        
        sessionManager?.request((config.requestURL?.requestURLString(baseURL: baseURL()))!, method: config.requestMethod, parameters: config.parameters)
            .responseJSON {[weak self] response in
                if response.result.isSuccess {
                    self?.handleRequestResult(config: config, response: response, complete: complete)
                }else{
                    self?.handleRequestFailResult(config: config, response: response, complete: complete);
                }
        }
    }
    
}

// MARK: - HanderResults
extension UYRequestManager {
    
    fileprivate func handleRequestResult(config:UYRequestConfig,response:DataResponse<Any>, complete:@escaping(_ result:Array<Any>,_ error:Error?) -> Void) {
        
        if let json = response.result.value as? [String : Any],
            let code = json["code"] as? Int,
            code == 0 {
            if let data = json["data"] as? NSDictionary {
                complete([data],nil)
            }else
                if let data = json["data"] as? Array<Any> {
                    complete(data,nil)
                }else{
                    complete([response],UYRequestError.UYResponseFail(code: -1, msg: "data数据为空"))
            }
            
            
        }else{
            handleRequestFailResult(config: config, response: response, complete: complete)
        }
    }
    
    fileprivate func handleRequestFailResult(config:UYRequestConfig,response:DataResponse<Any>, complete:@escaping(_ result:Array<Any>,_ error:Error?) -> Void) {
        
        var resultError :Error?
        if response.result.isSuccess {
            if let json = response.result.value as? [String : Any],
                let code = json["code"] as? Int,
                let msg = json["msg"] as? String
            {
                resultError = UYRequestError.UYResponseFail(code: code, msg: msg)
            }
        }else{
            resultError = UYRequestError.afRequestFail(error: response.error!)
        }
        complete([response],resultError)
    }
}
