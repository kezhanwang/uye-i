//
//  UYOrderView.swift
//  uye
//
//  Created by Tintin on 2017/11/17.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

/// 一个订单的View，由UYOrderBaseInfoView + UYOrderInfoView
class UYOrderView: UIView {
    
    fileprivate let orderBaseView = UYOrderBaseInfoView()
    fileprivate let orderDetailView = UYOrderInfoView()
    weak var delegate:UYOrderBaseInfoViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置页面
extension UYOrderView {
     fileprivate func setupUI() {
        addSubview(orderBaseView)
        addSubview(orderDetailView)
        
        orderBaseView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(UYOrderBaseInfoView.height)
        }
        orderBaseView.delegate = self
        orderBaseView.layer.cornerRadius = 20
        orderBaseView.layer.borderColor = UIColor(hexColor:"9e9e9e").cgColor
        orderBaseView.layer.borderWidth = 1
        orderBaseView.layer.masksToBounds = true
        
        orderDetailView.snp.makeConstraints { (make) in
            make.top.equalTo(orderBaseView.snp.bottom).offset(0)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-10)
        }
        
        orderDetailView.layer.cornerRadius = 20
        orderDetailView.layer.borderColor = UIColor(hexColor:"9e9e9e").cgColor
        orderDetailView.layer.borderWidth = 1
        orderDetailView.layer.masksToBounds = true
        
        let separatorView = UIImageView(image: #imageLiteral(resourceName: "order_separator_icon"))
        separatorView.backgroundColor = UIColor.white
        addSubview(separatorView)
        let height = separatorView.bounds.height
        
        separatorView.snp.makeConstraints { (make) in
            make.left.equalTo(32)
            make.right.equalTo(-32)
            make.top.equalTo(orderBaseView.snp.bottom).offset(-(height/2))
        }
    }
    func updateUI(orderInfo:UYOrderModel) {
        orderBaseView.updateUI(orderInfo: orderInfo)
        orderDetailView.updateUI(orderInfo: orderInfo)
        
    }
}
extension UYOrderView:UYOrderBaseInfoViewDelegate {
    func addEmploymentProgressAction() {
        if self.delegate != nil {
            self.delegate?.addEmploymentProgressAction()
        }
    }
    
    func haveJobsAction() {
        if self.delegate != nil {
         self.delegate?.haveJobsAction()
        }
    }
    
    func applyReparations() {
        if self.delegate != nil {
         self.delegate?.applyReparations()
        }
    }
    
    func compensationRecords() {
        if self.delegate != nil {
         self.delegate?.compensationRecords()
        }
    }
}
