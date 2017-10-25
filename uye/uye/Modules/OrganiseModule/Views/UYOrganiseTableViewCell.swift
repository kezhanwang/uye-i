//
//  UYOrganiseTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/17.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrganiseTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        categoryView.layer.cornerRadius = 4
        categoryView.layer.borderWidth = 1
        categoryView.layer.borderColor = UIColor(hexColor: "39aefb").cgColor
        categoryView.layer.masksToBounds = true
        setSelectedBackgroundViewLightGray()
    }
    func setupCell(organise:UYOrganiseModel)  {
        let imageUrl = URL(string: organise.logo ?? "")
        iconImageView.kf.setImage(with: imageUrl)
        nameLabel.text = organise.org_name
        distanceLabel.text = organise.distance
        categoryLabel.text = organise.category
        courseLabel.text = organise.popular
    }
    
    
}
