//
//  UYInputTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYInputTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var indexPath:IndexPath?
    weak var delegate:UYInputTableViewCellDelegate?
    var inputModel:UYInputModel? {
        didSet {
            nameLabel.text = inputModel?.title
            textField.placeholder = inputModel?.placeholder
            textField.keyboardType = (inputModel?.keyboardType)!
            textField.isEnabled = (inputModel?.textFieldEnable)!
            textField.text = inputModel?.content
            if (inputModel?.textFieldEnable)! {
                accessoryView = nil
            }else{
                setCellAccessoryDisclosureIndicator()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
    }

    @objc func textFieldTextChanged() {
//        inputModel?.content = textField.text!
        if delegate != nil {
            delegate?.textFieldTextDidChange!(indexPath: indexPath!, text: textField.text ?? "")
        }
    }
}
