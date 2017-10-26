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
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        webView.navigationDelegate = self
        contentView.addSubview(webView)
        
        
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
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webView加载完毕：\(webView.intrinsicContentSize)")
    }
}
