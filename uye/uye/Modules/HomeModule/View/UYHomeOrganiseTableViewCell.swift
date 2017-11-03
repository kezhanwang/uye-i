//
//  UYHomeOrganiseTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/19.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYHomeOrganiseTableViewCell: UITableViewCell {
    @IBOutlet weak var organiseLabel: UILabel!
    
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var searchView: UIView!
    weak var delegate:UYHomeOrganiseTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchView.layer.cornerRadius = searchView.bounds.height/2
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.themeColor.cgColor
        
    }
    func setupUI(organise:UYOrganiseModel) {
        if let name = organise.org_name {
            organiseLabel.isHidden = false
            let attributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),
                                                          NSAttributedStringKey.foregroundColor:UIColor.blackText]
            
            let mutableAttributedString = NSMutableAttributedString(string: "您当前的位置在\(name)", attributes: attributes)
            let range = NSMakeRange(7, name.count)
            
            mutableAttributedString.addAttributes([NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.greenText], range: range)
            
            organiseLabel.attributedText = mutableAttributedString
            guessLabel.isHidden = false
            searchView.isHidden = false
            
        }else{
            organiseLabel.isHidden = true
            guessLabel.isHidden = true
            searchView.isHidden = true
        }
    }
    @IBAction func siginAction(_ sender: Any) {
        if self.delegate != nil {
            if organiseLabel.isHidden {
                self.delegate?.homeSearchAction()
            }else{
                self.delegate?.hoemSiginAction()
            }
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.homeSearchAction()
        }
    }
    
}
@objc protocol UYHomeOrganiseTableViewCellDelegate :NSObjectProtocol {
    func hoemSiginAction()
    func homeSearchAction()
}
