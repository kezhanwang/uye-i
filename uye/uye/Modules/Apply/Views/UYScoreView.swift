//
//  UYScoreView.swift
//  uye
//
//  Created by Tintin on 2017/10/25.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit
fileprivate let starWidth = 12
class UYScoreView: UIView {
    var score:Float = 4.5 {
        didSet {
            for index in 1...5 {
                let imageView = self.viewWithTag(index) as! UIImageView
                if Float(index) < score {
                    imageView.image = #imageLiteral(resourceName: "apply_star_1")
                }else{
                    if Float(index) - score  > 1 {
                        imageView.image = #imageLiteral(resourceName: "apply_star_3")
                    }else{
                        imageView.image = #imageLiteral(resourceName: "apply_star_2")
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }

    fileprivate func configView() {
        for index in 1...5 {
            let imageView = UIImageView()
            imageView.tag = index
            addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
              make.left.equalTo((index-1)*(5+starWidth))
                make.centerY.equalTo(self.snp.centerY)
                make.width.equalTo(starWidth)
                make.height.equalTo(starWidth)
            })
        }
    }
}
