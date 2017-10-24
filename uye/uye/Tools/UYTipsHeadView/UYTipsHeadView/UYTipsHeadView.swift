//
//  UYTipsHeadView.swift
//  uye
//
//  Created by Tintin on 2017/10/20.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYTipsHeadView: UIView {
    var title:String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    fileprivate let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexColor: "fff8d8")
        let imageView = UIImageView(image: #imageLiteral(resourceName: "apply_tip_icon"))
        addSubview(imageView)
        addSubview(titleLabel)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(self)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(10)
            make.centerY.equalTo(self)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.orangeText

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


}
