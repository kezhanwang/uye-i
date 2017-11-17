//
//  UYOrderItemView.swift
//  uye
//
//  Created by Tintin on 2017/11/17.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

/// 一条日期信息
class UYOrderItemView: UIView {
    static let height:CGFloat = 27
    fileprivate let titleLabel = UILabel()
    fileprivate let contentLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension UYOrderItemView {
    fileprivate func setupUI()  {
        addSubview(titleLabel)
        addSubview(contentLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(16)
            make.width.equalTo(90)
            make.bottom.equalTo(-10)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.left.equalTo(100)
            make.right.equalTo(-16)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        setTinColor()
    }
    func updateUI(title:String,content:String)  {
        titleLabel.text = title
        contentLabel.text = content
    }
    func setTinColor(color:UIColor = UIColor.blackText) {
        titleLabel.textColor = color
        contentLabel.textColor = color
    }
}
