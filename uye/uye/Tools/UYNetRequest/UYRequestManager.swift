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


typealias RequestCompleteHandler = (Any,UYError?)->()

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
        //获取 UserAgent
        let webView  = UIWebView()
        let agentStr = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent")
        
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["User-Agent"] = agentStr
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
        if par == nil {
            par = [:];
        }
        par?["_t"] = NSDate().timeIntervalSince1970
        par?["phoneid"] = "deviceUUID"
        par?["map_lng"] = UYLocationManager.shared.longitude
        par?["map_lat"] = UYLocationManager.shared.latitude
        par?["version"] = appVersion
        return par!
    }
}


// MARK: - Make Requests
extension UYRequestManager {
    
    public func request<T:HandyJSON>(config:UYRequestConfig,type:T.Type, complete:RequestCompleteHandler? = nil) {
        let parameters = addBaseParameters(paramete: config.parameters)
        
        sessionManager?.request((config.requestURL?.requestURLString())!, method: config.requestMethod, parameters: parameters)
            .responseJSON {[weak self] response in
                
                guard (complete != nil) else { return }
                
                if response.result.isSuccess {
                    self?.handleRequestResult(config: config,type:type, response: response, complete: complete!)
                }else{
                    self?.handleRequestFailResult(response: response, complete: complete!)
                }
        }
    }
}

// MARK: - processing result
extension UYRequestManager {
    
    fileprivate func handleRequestResult<T:HandyJSON>(config:UYRequestConfig,type:T.Type,response:DataResponse<Any>, complete:RequestCompleteHandler) {
        if let json = response.result.value {
            
            let responseModel:UYResponseModel?  =  UYResponseModel<T>.deserialize(from: json as? Dictionary)
            if responseModel != nil {
                if responseModel?.code == 1000 {
                    complete(responseModel?.data ?? type,nil)
                }else{
                    handleRequestFailResult(response: response, complete: complete)
                }
            }else{
                complete([response],UYError.mapFailError())
            }
        }else{
            handleRequestFailResult(response: response, complete: complete)
        }
    }
    
    fileprivate func handleRequestFailResult(response:DataResponse<Any>, complete:RequestCompleteHandler) {
        
        var resultError :UYError?
        if response.result.isSuccess {
            if let json = response.result.value as? [String : Any],
                let code = json["code"] as? Int,
                let msg = json["msg"] as? String
            {
                resultError = UYError(code: code, msg: msg)
            }
        }else{
            let httpError = response.result.error! as NSError
            resultError = UYError(code: httpError.code, msg: httpError.localizedDescription)
        }
        complete([response],resultError)
    }
}

