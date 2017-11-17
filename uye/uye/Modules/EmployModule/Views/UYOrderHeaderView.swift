//
//  UYOrderHeaderView.swift
//  uye
//
//  Created by Tintin on 2017/11/17.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit


/// 订单小标题View
class UYOrderHeaderView: UIView {
    static let height :CGFloat = 45
    fileprivate var titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension UYOrderHeaderView {
    fileprivate func setupUI()  {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.bottom.equalTo(0)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.grayText
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lineGray
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
    }
    func updateUI(title:String) {
        titleLabel.text = title
    }
}
