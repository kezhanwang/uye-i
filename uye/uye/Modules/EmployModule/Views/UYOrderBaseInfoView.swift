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
    
    fileprivate let tipsLableTag : Int = 100 //提示语的label
    fileprivate let leftBtnTag : Int = 101 //左边按钮的tag
    fileprivate let rightBtnTag : Int = 102 //右边按钮的tag
    
    
    var organiseInfo:UYOrderModel?
    weak var delegate:UYOrderBaseInfoViewDelegate?
    
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
    func addTwoButton(titles:[String])  {
        removeSubView(tag: tipsLableTag)
        removeSubView(tag: leftBtnTag)
        removeSubView(tag: rightBtnTag)
        
        if titles.count > 0 {
            let rightBtn = UIButton()
            rightBtn.tag = rightBtnTag
            rightBtn.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
            rightBtn.setTitle(titles[0], for: .normal)
            rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            addSubview(rightBtn)
            rightBtn.layer.cornerRadius = 4
            rightBtn.layer.borderColor = UIColor.themeColor.cgColor
            rightBtn.layer.borderWidth = 1
            rightBtn.setTitleColor(UIColor.themeColor, for: .normal)
            rightBtn.snp.makeConstraints({ (make) in
                make.right.equalTo(-16)
                make.bottom.equalTo(-15)
                make.width.equalTo(75)
                make.height.equalTo(30)
            })
            
            if titles.count > 1 {
                let leftBtn = UIButton()
                leftBtn.tag = leftBtnTag
                leftBtn.addTarget(self, action: #selector(leftButtonAction(leftBtn:)), for: .touchUpInside)
                leftBtn.setTitle(titles[1], for: .normal)
                addSubview(leftBtn)
                leftBtn.layer.cornerRadius = 4
                leftBtn.layer.borderColor = UIColor.blackText.cgColor
                leftBtn.layer.borderWidth = 1
                leftBtn.setTitleColor(UIColor.blackText, for: .normal)

                leftBtn.snp.makeConstraints({ (make) in
                    make.right.equalTo(rightBtn.snp.left).offset(10)
                    make.bottom.equalTo(-15)
                    make.width.equalTo(75)
                    make.height.equalTo(40)
                })
                
            }
        }
        
    }
    func addTipsLabel(tips:String) {
        removeSubView(tag: tipsLableTag)
        removeSubView(tag: leftBtnTag)
        removeSubView(tag: rightBtnTag)
        guard tips.count > 0 else {
            return
        }
        let tipsLabel = UILabel()
        tipsLabel.textColor = UIColor.redText
        tipsLabel.font = UIFont.systemFont(ofSize: 14)
        tipsLabel.textAlignment = .right
        
        addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(-16)
            make.bottom.equalTo(0)
            make.right.equalTo(16)
            make.height.equalTo(20)
        }
    }
    func removeSubView(tag:Int)  {
        if let subView = viewWithTag(tag) {
            subView.removeFromSuperview()
        }
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
        let status :UYOrderStatus = UYOrderStatus(rawValue: orderInfo.insured_status )!
        
        
        switch status {
        case .inReviewOrder ,.inInsurance,.inTraining,.inReviewClaims,.timeOut://订单审核中
            addTwoButton(titles: ["我已就业"])
            break
        case .inChoosingCareer:
            addTwoButton(titles: ["我已就业","就业进展"])
            break
        case .waitingApplyClaims :
            addTwoButton(titles: ["我已就业","申请理赔"])
            break
        case.inPaying,.payFinish :
            addTwoButton(titles: ["我已就业","赔付记录"])
            break
        case  .haveJobs,.rejectOrder,.rejectClaims :
            addTipsLabel(tips: orderInfo.remark ?? "")
        default:
            break;
        }
    }
    
}

// MARK: - 按钮点击
extension UYOrderBaseInfoView {
    @objc func rightButtonAction()  {
        if self.delegate != nil {
            self.delegate?.haveJobsAction()
        }
    }
    @objc func leftButtonAction(leftBtn:UIButton) {
        if self.delegate != nil {
            if leftBtn.titleLabel?.text == "就业进展" {
                self.delegate?.addEmploymentProgressAction()
            }else if leftBtn.titleLabel?.text == "申请理赔" {
                self.delegate?.applyReparations()
            }else if leftBtn.titleLabel?.text == "赔付记录" {
                self.delegate?.compensationRecords()
            }
        }
    }
}

// MARK: - 回调协议
protocol UYOrderBaseInfoViewDelegate:NSObjectProtocol {
    
    func addEmploymentProgressAction()//添加就业进展
    func haveJobsAction()//已就业
    func applyReparations()//申请理赔
    func compensationRecords()//赔付记录
    
}
