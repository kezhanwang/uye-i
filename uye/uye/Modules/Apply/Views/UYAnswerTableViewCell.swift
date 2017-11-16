//
//  UYAnswerTableViewCell.swift
//  uye
//
//  Created by Tintin on 2017/10/18.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var accessView: UIView!
    weak var delegate:UYAnswerTableViewCellDelegate?
    var indexPath:IndexPath?
    
    func setCellSelected(selected:Bool) {
        let view = self.accessView.viewWithTag(1)
        view?.removeFromSuperview()
        
        if selected {
            let acceView = UIImageView(image: #imageLiteral(resourceName: "select_icon"))
            acceView.tag = 1
            self.accessView.insertSubview(acceView, at: 1)
            
        }else{
            let acceView = UYUncheckView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            acceView.tag = 1
            self.accessView.insertSubview(acceView, at: 1)
        }
    }
    @IBAction func selectedAction(_ sender: Any) {
        if delegate != nil {
            delegate?.selectedIndexCell(indexPath: self.indexPath!)
        }
    }
}
protocol UYAnswerTableViewCellDelegate:NSObjectProtocol {
    func selectedIndexCell(indexPath:IndexPath)
}
