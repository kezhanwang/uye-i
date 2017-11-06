//
//  UYOrganiseInfoCell.swift
//  uye
//
//  Created by Tintin on 2017/10/25.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrganiseInfoCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var scoreView: UYScoreView!
    @IBOutlet weak var signBtn: UIButton!
    
    weak var delegate: UYOrganiseInfoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        translatesAutoresizingMaskIntoConstraints = false
        logoImageView.layer.cornerRadius = 4
        logoImageView.layer.masksToBounds = true
        
        categoryView.layer.cornerRadius = 4
        categoryView.layer.borderWidth = 1
        categoryView.layer.borderColor = UIColor.blueTextColor.cgColor
        categoryView.layer.masksToBounds = true
        
        signBtn.layer.cornerRadius = 4
        signBtn.layer.masksToBounds = true

    }
    var organiseInfo:UYOrganiseModel? {
        didSet {
            if let url = URL(string: organiseInfo?.logo ?? "") {
                logoImageView.kf.setImage(with: url)
            }
            nameLabel.text = organiseInfo?.org_name
            if organiseInfo?.category?.count ?? 0 > 0 {
                
                categoryLabel.text = organiseInfo?.category
                categoryView.isHidden = false
            }else{
              categoryView.isHidden = true
            }
            scoreView.score = Float(organiseInfo?.employment_index ?? "0")!
            
        }
    }
    

    @IBAction func signAction(_ sender: Any) {
        if delegate != nil {
            delegate?.signOrganiseCellAction()
        }
    }
    
}
protocol UYOrganiseInfoCellDelegate :NSObjectProtocol {
    func signOrganiseCellAction()
}
