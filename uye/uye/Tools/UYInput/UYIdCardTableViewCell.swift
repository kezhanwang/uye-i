//
//  UYIdCardTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYIdCardTableViewCell: UITableViewCell {

    weak var delegate:UYIdCardTableViewCellDelegate?
    @IBOutlet weak var faceBtn: UIButton!
    @IBOutlet weak var emblemBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func idCardFaceAction(_ sender: Any) {
        if delegate != nil {
            delegate?.idcardInfoFaceAction()
        }
    }
    
    @IBAction func idCardEmblem(_ sender: Any) {
        if delegate != nil {
            delegate?.idcardNationAction()
        }
    }
}
protocol UYIdCardTableViewCellDelegate: NSObjectProtocol {
    func idcardInfoFaceAction()
    func idcardNationAction()
}
