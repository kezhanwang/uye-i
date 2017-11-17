//
//  UYOrderInfoView.swift
//  uye
//
//  Created by Tintin on 2017/11/17.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

/// 订单信息、培训信息
class UYOrderInfoView: UIView {
    let sectionSpace:CGFloat = 30
    
    var topCount :CGFloat = 0
    
    fileprivate let trainHeadView = UYOrderHeaderView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置页面
extension UYOrderInfoView {
    
    /// 设置默认页面，有一个订单信息，一个培训信息
    fileprivate func setupUI()  {
        let orderHeader = UYOrderHeaderView()
        addSubview(orderHeader)
        orderHeader.updateUI(title: "订单信息")
        orderHeader.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(UYOrderHeaderView.height)
        }
        
        addSubview(trainHeadView)
        trainHeadView.updateUI(title: "培训信息")
        trainHeadView.snp.makeConstraints { (make) in
            make.top.equalTo(UYOrderHeaderView.height + sectionSpace)
            make.left.right.equalTo(0)
            make.height.equalTo(UYOrderHeaderView.height)
        }
        
    }
    func updateUI(orderInfo:UYOrderModel) {
        //清空View重新添加
        for subView in subviews {
            if subView.isKind(of: UYOrderItemView.classForCoder()) {
                subView.removeFromSuperview()
            }
        }
        topCount = 0
        let currentHeight:CGFloat = UYOrderHeaderView.height 
        var preItemView : UIView!
        
        //赔付上限
        let maxPay = (orderInfo.premium_amount_top ?? 0) / 100
        if maxPay > 0 {
            topCount += 1
            let itemView = UYOrderItemView()
            addSubview(itemView)
            itemView.snp.makeConstraints({ (make) in
                make.top.equalTo(currentHeight)
                make.left.right.equalTo(0)
            })
            itemView.updateUI(title: "赔付上限", content: "￥\(maxPay)")
            preItemView = itemView
        }
       
        //择业日期
       preItemView = chargeContentText(perItemView: preItemView, title: "择业日期", content: orderInfo.career_time)
        
        //理赔日期
        preItemView = chargeContentText(perItemView: preItemView, title: "理赔日期", content: orderInfo.repay_time)
        
        updateUIConstraints(count: topCount)

        //培训日期
        preItemView = chargeContentText(perItemView: trainHeadView, title: "培训日期", content: orderInfo.train?.first_train)
        //再培训日期
        preItemView = chargeContentText(perItemView: preItemView, title: "再培训日期", content: orderInfo.train?.second_train)
        //结业日期
        chargeContentText(perItemView: preItemView, title: "结业日期", content: orderInfo.train?.end_train)
        
    }
    
    @discardableResult
    func chargeContentText(perItemView:UIView,title:String,content:String?) -> UIView {
        let contentTextCount = content?.count ?? 0
        if contentTextCount > 0 {
           return addItemView(perItemView: perItemView, title: title, content: content!)
        }
        return perItemView
    }
    func addItemView(perItemView:UIView,title:String,content:String) -> UIView {
        topCount += 1
        let itemView = UYOrderItemView()
        addSubview(itemView)
        itemView.snp.makeConstraints({ (make) in
            make.top.equalTo(perItemView.snp.bottom).offset(0)
            make.left.right.equalTo(0)
//            make.height.equalTo(UYOrderItemView.height)
        })
        itemView.updateUI(title: title, content: content)
        return itemView
    }
    
    /// 更新培训信息的位置
    /// - Parameter topCount: 上面的条目个数
    fileprivate func updateUIConstraints(count:CGFloat) {
        trainHeadView.snp.updateConstraints { (make) in
            let height = UYOrderHeaderView.height + UYOrderItemView.height * count + sectionSpace
            make.top.equalTo(height)
        }
    }
    
    
    
}
