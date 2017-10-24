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
        
    }
    func setupUI(organise:UYOrganiseModel) {
        if let name = organise.org_name {
            organiseLabel.isHidden = false
            let attributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),
                                                          NSAttributedStringKey.foregroundColor:UIColor.blackText]
            
            let mutableAttributedString = NSMutableAttributedString(string: "您当前的位置在\(name)", attributes: attributes)
            let range = NSMakeRange(7, name.characters.count)
            
            mutableAttributedString.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.greenText], range: range)
            
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
