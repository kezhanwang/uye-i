//
//  UYOrganiseOrderTableCell.swift
//  uye
//
//  Created by Tintin on 2017/10/19.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrganiseOrderTableCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryView.layer.cornerRadius = 4
        categoryView.layer.borderWidth = 1
        categoryView.layer.borderColor = UIColor(hexColor: "39aefb").cgColor
        categoryView.layer.masksToBounds = true
    }

    var organise:UYOrganiseModel? {
        didSet {
            guard organise != nil else {
                return
            }
            if let url = URL(string: (organise?.logo)!) {
                iconImageView.kf.setImage(with: url)
            }
            nameLabel.text = organise?.org_name
            categoryLabel.text = organise?.category
            if let price:String = organise?.avg_course_price {
        
                priceLabel.text = "￥\(Int(price)!*100)"
            }
            
            
        }
    }
    
    
}
