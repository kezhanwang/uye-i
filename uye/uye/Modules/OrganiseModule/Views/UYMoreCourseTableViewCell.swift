//
//  UYMoreCourseTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/26.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYMoreCourseTableViewCell: UITableViewCell {
    @IBOutlet weak var courseLogo1: UIImageView!
    @IBOutlet weak var courseLogo2: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        courseLogo1.layer.cornerRadius = 4
        courseLogo1.layer.masksToBounds = true
        
        courseLogo2.layer.cornerRadius = 4
        courseLogo2.layer.masksToBounds = true
        
        let layer  = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor ,UIColor.white.cgColor,UIColor.red.cgColor]
        layer.locations = [0,0.2,1]
        layer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: bgView.bounds.height)
        bgView.layer.mask = layer
        
        
    }
    
    var courseInfo1:UYCourseModel? {
        didSet {
            if let url = URL(string: courseInfo1?.logo ?? "") {
                courseLogo1.kf.setImage(with: url)
            }
        }
    }
    var courseInfo2:UYCourseModel? {
        didSet {
            if courseInfo2 != nil {
                courseLogo2.isHidden = false
                if let url = URL(string: courseInfo2?.logo ?? "") {
                    courseLogo2.kf.setImage(with: url)
                }
            }else{
                courseLogo2.isHidden = true
            }
            
        }
    }
    
     func showMoreCourseAction(_ sender: Any) {
        
    }
    
    
}
