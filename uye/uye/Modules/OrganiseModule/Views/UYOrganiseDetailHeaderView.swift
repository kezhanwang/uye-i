//
//  UYOrganiseDetailHeaderView.swift
//  uye
//
//  Created by Tintin on 2017/10/25.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrganiseDetailHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = UIColor.white
    }

}
