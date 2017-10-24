//
//  UYOrderCollectionViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/23.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIScrollView! //背景Scroll
    @IBOutlet weak var headerBackView: UIView! //上半部分
    @IBOutlet weak var orderBackView: UIView! //下半部分
    
    @IBOutlet weak var orderNumLabel: UILabel! // 订单号
    @IBOutlet weak var orderStatusLabel: UILabel! //订单状态
    
    @IBOutlet weak var organiseLogoImageView: UIImageView! // 机构logo
    @IBOutlet weak var organiseNameLabel: UILabel! //机构名字
    @IBOutlet weak var orderTypeLabel: UILabel! //订单类型
    @IBOutlet weak var priceLabel: UILabel! // 订单价格
    @IBOutlet weak var reasonLabel: UILabel! //拒绝的原因
    
    @IBOutlet weak var mostPayLabel: UILabel! //最高赔付
    @IBOutlet weak var careerDatesLabel: UILabel! //择业日期
    @IBOutlet weak var repayDatesLabel: UILabel! //理赔日期
    
    @IBOutlet weak var firstTrainDatesLabel: UILabel! //培训日期
    @IBOutlet weak var secondTrainDateLabel: UILabel! //再培训日期
    @IBOutlet weak var endTrainLabel: UILabel! //结业日期
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.background
        bgView.alwaysBounceHorizontal = false
        headerBackView.layer.cornerRadius = 20
        headerBackView.layer.borderColor = UIColor(hexColor:"9e9e9e").cgColor
        headerBackView.layer.borderWidth = 1
        headerBackView.layer.masksToBounds = true
        
        orderBackView.layer.cornerRadius = 20
        orderBackView.layer.borderColor = UIColor(hexColor:"9e9e9e").cgColor
        orderBackView.layer.borderWidth = 1
        orderBackView.layer.masksToBounds = true
    }
    
    var order:UYOrderModel? {
        didSet {
            if order != nil {
                bgView.isHidden = false
                
                orderNumLabel.text = "订单编号：\(order!.insured_order ?? "")"
                orderStatusLabel.text = order!.insured_status_desp
                
                if let url = URL(string: order?.org_logo ?? "" ) {
                    organiseLogoImageView.kf.setImage(with: url)
                }
                organiseNameLabel.text = order?.org_name
                orderTypeLabel.text = "类型：\(order!.insured_type ?? "")"
                
                let realPrice = order!.tuition!/100
                let realPriceStr = "\(realPrice)"
                
                let attribute = NSMutableAttributedString(string: "学费：￥\(realPriceStr)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13),NSAttributedStringKey.foregroundColor:UIColor(hexColor: "999999")])
                attribute.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor(hexColor: "515151")], range: NSMakeRange(3, realPriceStr.characters.count+1))
                priceLabel.attributedText = attribute
                
              
                reasonLabel.text = order?.remark
                
                let maxPay = order!.premium_amount_top! / 100
                mostPayLabel.text = "￥\(maxPay)"
                
                careerDatesLabel.text = order?.career_time
                repayDatesLabel.text = order?.repay_time
                firstTrainDatesLabel.text  = order?.train?.first_train
                secondTrainDateLabel.text = order?.train?.second_train
                endTrainLabel.text = order?.train?.end_train
              
            }else{
                bgView.isHidden = true
            }
        }
    }
    

}
