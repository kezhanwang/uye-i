//
//  UYCourseTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/25.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseLogo1: UIImageView!
    @IBOutlet weak var courseNameLabel1: UILabel!
    @IBOutlet weak var courseLogo2: UIImageView!
    @IBOutlet weak var courseNameLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        courseLogo1.layer.cornerRadius = 4
        courseLogo1.layer.masksToBounds = true
        
        courseLogo2.layer.cornerRadius = 4
        courseLogo2.layer.masksToBounds = true
    }
    
    var courseInfo1:UYCourseModel? {
        didSet {
            if let url = URL(string: courseInfo1?.logo ?? "") {
                courseLogo1.kf.setImage(with: url)
            }
            courseNameLabel1.text = courseInfo1?.c_name
        }
    }
    var courseInfo2:UYCourseModel? {
        didSet {
            if courseInfo2 != nil {
                courseLogo2.isHidden = false
                courseNameLabel2.isHidden = false
                if let url = URL(string: courseInfo2?.logo ?? "") {
                    courseLogo2.kf.setImage(with: url)
                }
                courseNameLabel2.text = courseInfo2?.c_name
                
            }else{
                courseLogo2.isHidden = true
                courseNameLabel2.isHidden = true
            }
            
        }
    }
    

    
}
