//
//  UYWebViewController.swift
//  uye
//
//  Created by Tintin on 2017/9/16.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import WebKit
private var myProgressContext = 0
private var myTitleContext = 1
private let webViewProgressKey = "estimatedProgress"
private let webViewTitleKey = "title"
class UYWebViewController: UYBaseViewController {

    // MARK: - 需要外面出入的字段
    /// 传入的URLString
    var urlString :String?
    // MARK: - 本地字段属性
    fileprivate let webView :WKWebView = WKWebView()
    fileprivate let progressView :UIProgressView = UIProgressView()
    
    fileprivate var loadCount :Float = 0 {
        didSet {
            if (loadCount == 0) {
                progressView.isHidden = true;
                progressView.setProgress(0, animated: false)
                
            }else{
                progressView.isHidden = false
                
                let oldP = progressView.progress
                var newP = (1.0  - oldP) / (loadCount + 1.0 ) + oldP
                
                if (newP > 0.95) {
                    newP = 0.95;
                }
                progressView.setProgress(newP, animated: true)
                
            }
        }
    }
    
    // MARK: - 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    func loadData() {
        if let urlStr = urlString {
            
            if let url  = NSURL(string: urlStr) {
                let request = NSURLRequest(url: url as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
                webView.load(request as URLRequest)
            }
        }
    }
    deinit {
        webView.removeObserver(self, forKeyPath: webViewProgressKey, context: &myProgressContext)
        webView.removeObserver(self, forKeyPath: webViewTitleKey, context: &myTitleContext)
        
    }

}
// MARK: - 设置界面
extension UYWebViewController {
    override func setupUI() {
        setupNavigation()
        automaticallyAdjustsScrollViewInsets = false
        
        webView.frame = CGRect(x: 0, y: navigationBarHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-navigationBarHeight)
        webView.navigationDelegate = self
        view.insertSubview(webView, belowSubview: navigationBar)
        
        progressView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2)
        progressView.progressTintColor = UIColor.themeColor()
        progressView.trackTintColor = UIColor.white
        view.insertSubview(progressView, belowSubview: navigationBar)
        
        
        webView.addObserver(self, forKeyPath: webViewProgressKey, options: .new, context: &myProgressContext)
        webView.addObserver(self, forKeyPath: webViewTitleKey, options: .new, context: &myTitleContext)
    }
}

// MARK: - 观察进度
extension UYWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myProgressContext {
            if keyPath == webViewProgressKey {
                if let newValue = change?[NSKeyValueChangeKey.newKey] {
                    let progressValue = newValue as! Float
                    progressView.progress = progressValue
                    if progressValue >= 1 {
                        progressView.isHidden = true
                    }else{
                        progressView.isHidden = false
                    }
                    
                }
            }
        }else if context == &myTitleContext {
            if keyPath == webViewTitleKey {
                navigationItemKZ.title = webView.title
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - WKNavigationDelegate
extension UYWebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
        loadCount += 1
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webViewdidCommit")
        loadCount -= 1
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败了？？？")
        loadCount -= 1
    }
}
