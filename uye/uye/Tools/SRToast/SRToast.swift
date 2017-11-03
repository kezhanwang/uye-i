
//
//  SRToast.swift
//  ToastDemo
//
//  Created by Tintin on 2017/11/1.
//  Copyright © 2017年 Tintin. All rights reserved.
//

import UIKit

func showWaitToast() {
    SRToast.showWaitToast()
}
func dismissWaitToast() {
    SRToast.dismissWaitToast()
}

func showTextToast(msg:String) {
    SRToast.showTextToast(msg: msg)
}

func showProgressToast(progress:Progress) {
    DispatchQueue.main.async {
        SRToast.showProgressToast(progress: progress)
    }
//    DispatchQueue.main.asyncAfter(deadline: 0.1) {
//        progress.completedUnitCount += 1
//        SRToast.showProgressToast(progress: progress)
//        if progress.fractionCompleted < 1 {
//            showProgressToast(progress: progress)
//        }
//    }
    
}
class SRToast: NSObject {
    
    static let loadingWindow = UIWindow()
    
    /// 等待的View是否加载中
    static var isWaitToastShowing = false
    
    static var progressView:SRProgressView?
    /// 展示文本提示
    /// - Parameter msg: 提示的内容
    static func showTextToast(msg:String) {
        if isWaitToastShowing == true {
            dismissWaitToast()
        }

        let length = msg.count
        guard length >= 0 else {
            return
        }
        var time:Double = Double(length) * 0.05
        if time < 1.5 {
            time = 1.5
        }
        let toast =  SRTextToast(msg: msg)
        
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        window.addSubview(toast)
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        window.frame = toast.bounds
        
        window.center = CGPoint(x: screenWidth/2, y: screenHeight/2-50)
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(floatLiteral: time)) {
            window.alpha = 0
            window.isHidden = true
        }
    }
    
    
    /// 展示加载提示框，其实loadingWindow并不会释放，但子类会全部释放掉
    static func showWaitToast() {
        
        guard isWaitToastShowing == false else { return }
        
        isWaitToastShowing = true
        let waitToast = SRWaitToast()
        loadingWindow.backgroundColor = UIColor.clear
        loadingWindow.addSubview(waitToast)
        loadingWindow.alpha = 1
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        loadingWindow.frame = waitToast.bounds

        loadingWindow.center = CGPoint(x: screenWidth/2, y: screenHeight/2-50)
        loadingWindow.windowLevel = UIWindowLevelAlert
        loadingWindow.isHidden = false
        
    }
    
    /// 加载提示框小时
    static func dismissWaitToast() {
        isWaitToastShowing = false
        for view in loadingWindow.subviews {
            view.removeFromSuperview()
        }
        loadingWindow.alpha = 0
        loadingWindow.isHidden = true
    }
    
    static func showProgressToast(progress:Progress) {
        if isWaitToastShowing {//如果正在显示等待加载，则移除他
            for view in loadingWindow.subviews {
                view.removeFromSuperview()
            }
            isWaitToastShowing = false
        }
        if progressView == nil {
            progressView = SRProgressView()
        }
        if loadingWindow.subviews.count == 0 {
            loadingWindow.addSubview(progressView!)
            loadingWindow.frame = progressView!.bounds
            
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            
            loadingWindow.backgroundColor = UIColor.clear
            loadingWindow.center = CGPoint(x: screenWidth/2, y: screenHeight/2-50)
            loadingWindow.windowLevel = UIWindowLevelAlert
            loadingWindow.isHidden = false
        }
        
        isWaitToastShowing = false
        progressView?.value = CGFloat(progress.fractionCompleted*100)
        if (progress.fractionCompleted >= 1) {
            progressView?.removeFromSuperview()
            showWaitToast()
        }
    }

}

extension DispatchTime :ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}
extension DispatchTime :ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
