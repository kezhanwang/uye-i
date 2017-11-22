//
//  UYOrderCollectionViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/23.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrderCollectionViewCell: UICollectionViewCell {
   
    let orderView = UYOrderView()
    weak var delegate:UYOrderBaseInfoViewDelegate?
    var indexPath:IndexPath?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBackgroundView()
        contentView.addSubview(orderView)
        orderView.delegate = self
        orderView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.clear
    }
    
    var order:UYOrderModel? {
        didSet {
            if order != nil {
                orderView.isHidden = false
                orderView.updateUI(orderInfo: order!)
               
            }else{
                orderView.isHidden = true
            }
        }
    }
    
    func setBackgroundView()  {
        let backgroundView = UIView()
        contentView.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight-kTabBarHeight-kNavigationHeight)
        //设置渐变的主颜色
        gradientLayer.colors = [UIColor(hexColor: "C9C9C9").cgColor, UIColor(hexColor: "e3e3e3").cgColor]
        backgroundView.layer.addSublayer(gradientLayer)
        
    }
    

}
extension UYOrderCollectionViewCell:UYOrderBaseInfoViewDelegate {
    func addEmploymentProgressAction() {
        if self.delegate != nil {
            self.delegate?.addEmploymentProgressAction()
        }
    }
    
    func haveJobsAction() {
        if self.delegate != nil {
            self.delegate?.haveJobsAction()
        }
    }
    
    func applyReparations() {
        if self.delegate != nil {
            self.delegate?.applyReparations()
        }
    }
    
    func compensationRecords() {
        if self.delegate != nil {
            self.delegate?.compensationRecords()
        }
    }
}
