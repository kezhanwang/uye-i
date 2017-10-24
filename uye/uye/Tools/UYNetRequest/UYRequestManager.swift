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
import FCUUID

typealias RequestCompleteHandler = (Any,UYError?)->()
typealias UploadProgressHandler = (Progress) -> Void
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
        defaultHeaders["HTTP_UYEUA"] = UIDevice.current.deviceInfo
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        configuration.timeoutIntervalForRequest = 30
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
        let xx = getMAC()
        if xx.success {
            par?["mac"] = xx.mac
            par?["ssid"] = xx.ssid
        }
        
        par?["_t"] = NSDate().timeIntervalSince1970
        par?["phoneid"] = UIDevice.current.uuid()
        par?["map_lng"] = UYLocationManager.shared.longitude
        par?["map_lat"] = UYLocationManager.shared.latitude
        par?["version"] = localAppVersion //appVersion
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
    public func uploadImageRequest(config:UYRequestConfig,uploadProgress:@escaping UploadProgressHandler,complete:RequestCompleteHandler? = nil){
       
        sessionManager?.upload(multipartFormData: { (multipartFormData) in
           
            for imageModel:UYImageModel in config.images! {
                multipartFormData.append(imageModel.data!, withName: imageModel.name!, fileName: imageModel.name!, mimeType: "image/png")
            }
            
        }, to: (config.requestURL?.requestURLString())!, encodingCompletion: { (encodingResult) in
            guard (complete != nil) else { return }
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: {[weak self] (response) in
                    if response.result.isSuccess {
                        self?.handleRequestSuccess(response: response, complete: complete!)
                    }else{
                        self?.handleRequestFailResult(response: response, complete: complete!)
                    }
                })
            case .failure(let error):
                print(error)
            }
            
        
        })

    }
}

// MARK: - processing result
extension UYRequestManager {
    
    fileprivate func handleRequestResult<T:HandyJSON>(config:UYRequestConfig,type:T.Type,response:DataResponse<Any>, complete:RequestCompleteHandler) {
        if let json = response.result.value as? Dictionary<String, Any> {
            
            if (json["data"] as? [Any]) != nil {
                let res :UYResponseArrayModel? = UYResponseArrayModel<T>.deserialize(from: json)
                if res != nil {
                    if res?.code == 1000 {
                        complete(res?.data ?? type,nil)
                    }else{
                        handleRequestFailResult(response: response, complete: complete)
                    }
                }else{
                    complete([response],UYError.mapFailError())
                }
            }else{
                let responseModel:UYResponseModel?  =  UYResponseModel<T>.deserialize(from: json)
                if responseModel != nil {
                    if responseModel?.code == 1000 {
                        complete(responseModel?.data ?? type,nil)
                    }else{
                        handleRequestFailResult(response: response, complete: complete)
                    }
                }else{
                    complete([response],UYError.mapFailError())
                }
            }
            
        }else{
            handleRequestFailResult(response: response, complete: complete)
        }
    }
    fileprivate func handleRequestSuccess(response:DataResponse<Any>, complete:@escaping RequestCompleteHandler) {
        if let json = response.result.value as? Dictionary<String, Any> {
            
            if let code = json["code"] as? Int {
                if code == 1000 {
                    complete(json["data"] as Any,nil)
                }else{
                    handleRequestFailResult(response: response, complete: complete)
                }
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

