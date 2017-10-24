//
//  UYQuestionHeaderView.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYQuestionHeaderView: UITableViewHeaderFooterView {
    var titleLabel :UILabel = UILabel()
    var tipsLabel : UILabel = UILabel()
    var question:UYQuestion? {
        didSet {
            titleLabel.text = question?.question
            if question?.type == "2" {
                tipsLabel.isHidden = false
                titleLabel.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(-20)
                })
            }else{
                tipsLabel.isHidden = true
                titleLabel.snp.updateConstraints({ (make) in
                    make.bottom.equalTo(-10)
                })
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tipsLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(-16);
            make.left.equalTo(16)
        }
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.bottom.equalTo(-5)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.blackText
        tipsLabel.font = UIFont.systemFont(ofSize: 13)
        tipsLabel.textColor = UIColor(hexColor: "fb6f00")
        tipsLabel.text = "注：此题为多选"
        contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func heightWithQuestion(question:UYQuestion) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth-32, height: 888))
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = question.question
        label.sizeToFit()
        var expectHeight = label.frame.size.height+30
        
        if question.type == "2" {
            expectHeight = expectHeight + 20
        }
        return expectHeight
    }

}
