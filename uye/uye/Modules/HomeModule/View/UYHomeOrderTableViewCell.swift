//
//  UYHomeOrderTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/19.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYHomeOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var payMoneyLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    
    @IBOutlet weak var payedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupUI(order:UYHomeOrder,premiumTop:Double) {
        if order.compensation == 0 {
            titleLabel.text = "最高赔付（元）"
            payMoneyLabel.text = "\(premiumTop/100)"
        }else{
            titleLabel.text = "赔付金额（元）"
            
            payMoneyLabel.text = "\(order.compensation/100)"
        }
        orderCountLabel.text = "\(order.count)"
        payedLabel.text = "￥\(order.paid_compensation/100)"
    }

  
    
}
