//
//  UYCloseCourseTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/11/22.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYCloseCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var closeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var showClose:Bool = false {
        didSet {
            closeView.isHidden = !showClose
        }
    }
    
    
}
