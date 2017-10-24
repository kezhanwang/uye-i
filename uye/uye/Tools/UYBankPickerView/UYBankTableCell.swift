//
//  UYBankTableCell.swift
//  uye
//
//  Created by Tintin on 2017/10/22.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYBankTableCell: UITableViewCell {

    @IBOutlet weak var bankIcon: UIImageView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectImageView.isHidden = !selected
      
    }
    
}
