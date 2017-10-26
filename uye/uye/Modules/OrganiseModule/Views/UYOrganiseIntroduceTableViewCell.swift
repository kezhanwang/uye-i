//
//  UYOrganiseIntroduceTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/25.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
import WebKit
class UYOrganiseIntroduceTableViewCell: UITableViewCell {

    let webView:WKWebView = WKWebView()
    weak var delegate:UYOrganiseIntroduceTableViewCellDelegate?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        contentView.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
      
    }
    var urlString:String?{
        didSet {
            if let url = URL(string: urlString!) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UYOrganiseIntroduceTableViewCell : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.scrollView.contentSize.height)
        if webView.isLoading == false {
            webView.evaluateJavaScript("document.body.scrollHeight") {[weak self] (result, error) in
                if let height = result as? CGFloat {
                    if self?.delegate != nil {
                        self?.delegate?.IntroduceTableViewCellHeightChanged(expectHeight: height)
                    }
                }
            }
        }
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
       
        
    }
 
}
protocol UYOrganiseIntroduceTableViewCellDelegate:NSObjectProtocol {
    func IntroduceTableViewCellHeightChanged(expectHeight:CGFloat)
}
