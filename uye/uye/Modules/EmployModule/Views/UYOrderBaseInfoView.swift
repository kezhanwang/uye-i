//
//  UYOrderBaseInfoView.swift
//  uye
//
//  Created by Tintin on 2017/11/17.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

/// 订单页面的上半部分，基本信息
class UYOrderBaseInfoView: UIView {
    static let height :CGFloat = 200
    
    var organiseInfo:UYOrderModel?
    
    fileprivate let orderNumLabel = UILabel()//订单号
    fileprivate let orderStatusLabel = UILabel()//订单状态
    fileprivate let organiseLogoView = UIImageView()//机构logo
    fileprivate let organiseNameLabel = UILabel()//机构名字
    fileprivate let orderTypeLabel = UILabel()//订单的类型
    fileprivate let rganiseTuitionLabel = UILabel()//课程价格
    
    /*
     备注提示语（tag = 10）、我已就业(11)、就业进展(12)、申请理赔(11)、赔付记录(12)等按钮是可能不展示的。所以就不设置成全局的了
     */    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置页面
extension UYOrderBaseInfoView {
    func setupUI()  {
        //头部的蓝绿色
        let headView = UIView()
        headView.backgroundColor = UIColor(hexColor: "99E7D7")
        addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(32)
        }
        //分割线
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lineGray
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(32+44)
            make.height.equalTo(0.5)
        }
        
        addSubview(orderNumLabel)
        addSubview(orderStatusLabel)
        addSubview(organiseLogoView)
        addSubview(organiseNameLabel)
        addSubview(orderTypeLabel)
        addSubview(rganiseTuitionLabel)
        
        orderNumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(headView.snp.bottom).offset(0)
            make.bottom.equalTo(lineView.snp.top).offset(0)
            make.width.equalTo(50).priority(250)
        }
        orderStatusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.top.equalTo(headView.snp.bottom).offset(0)
            make.bottom.equalTo(lineView.snp.top).offset(0)
            make.left.equalTo(orderNumLabel.snp.right).offset(3).priority(250)
            make.width.equalTo(50).priority(250)
        }
        
        
        organiseLogoView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(60)
        }
        organiseNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(organiseLogoView.snp.right).offset(14)
            make.right.equalTo(-16)
            make.top.equalTo(organiseLogoView.snp.top)
        }
        orderTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(organiseLogoView.snp.right).offset(14)
            make.right.equalTo(-16)
            make.top.equalTo(organiseNameLabel.snp.bottom).offset(5)
        }
        rganiseTuitionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(organiseLogoView.snp.right).offset(14)
            make.right.equalTo(-16)
            make.top.equalTo(orderTypeLabel.snp.bottom).offset(10)
        }
        
        organiseLogoView.backgroundColor = UIColor.lightBackground
        orderNumLabel.font = UIFont.systemFont(ofSize: 12)
        orderStatusLabel.font = UIFont.systemFont(ofSize: 12)
        organiseNameLabel.font = UIFont.systemFont(ofSize: 15)
        orderTypeLabel.font = UIFont.systemFont(ofSize: 12)
        
        orderNumLabel.textColor = UIColor.blackText
        orderStatusLabel.textColor = UIColor.blackText
        organiseNameLabel.textColor = UIColor.blackText
        orderTypeLabel.textColor = UIColor.grayText
        
        orderStatusLabel.textAlignment = .right
        
    }
    
    func updateUI(orderInfo:UYOrderModel) {
        orderNumLabel.text = "订单编号：\(orderInfo.insured_order ?? "")"
        orderStatusLabel.text = orderInfo.insured_status_desp
        
        if let url = URL(string: orderInfo.org_logo ?? "" ) {
            organiseLogoView.kf.setImage(with: url)
        }
        organiseNameLabel.text = orderInfo.org_name
        orderTypeLabel.text = "类型：\(orderInfo.insured_type ?? "")"
        
        let realPrice = (orderInfo.tuition ?? 0)/100
        let realPriceStr = "\(realPrice)"
        
        let attribute = NSMutableAttributedString(string: "学费：￥\(realPriceStr)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.grayText])
        attribute.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12),NSAttributedStringKey.foregroundColor:UIColor.blackText], range: NSMakeRange(3, 1))
        
        attribute.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.blackText], range: NSMakeRange(4, realPriceStr.count))
        rganiseTuitionLabel.attributedText = attribute
        
        
        
    }
    
}

// MARK: - 按钮点击
extension UYOrderBaseInfoView {
    
}

// MARK: - 回调协议
protocol UYOrderBaseInfoViewDelegate:NSObjectProtocol {
    
    func addEmploymentProgressAction()//添加就业进展
    func haveJobsAction()//已就业
    func applyReparations()//申请理赔
    func compensationRecords()//赔付记录
    
}
