//
//  UYInputBtnTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYInputBtnTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var verBtn: UIButton!
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
    
    @IBAction func cellGetCodeAction(_ sender: Any) {
        if delegate != nil {
            delegate?.getCodeAction!()
        }
    }
    
    
}
@objc protocol UYInputTableViewCellDelegate:NSObjectProtocol {
    @objc optional func getCodeAction()
    @objc optional func textFieldTextDidChange(indexPath:IndexPath,text:String)
    @objc optional func uploadImageAction(indexPath:IndexPath, index:Int)
}
