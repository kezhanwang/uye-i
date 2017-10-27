//
//  UYOrganiseBottomBar.swift
//  uye
//
//  Created by Tintin on 2017/10/27.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYOrganiseBottomBar: UIView {
    
    var delegate:UYOrganiseBottomBarDelegate?
    
    static func loadBottomBar() -> UYOrganiseBottomBar? {
        let nibViews = Bundle.main.loadNibNamed("UYOrganiseBottomBar", owner: nil, options: nil)
        if let view = nibViews?.first as? UYOrganiseBottomBar {
            return view
        }
        return nil
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    @IBOutlet weak var collectionImageView: UIImageView!
    
    @IBAction func collectAction(_ sender: Any) {
        if delegate != nil {
            delegate?.collectOrganiseAction()
        }
    }
    
    @IBAction func callPhoneAction(_ sender: Any) {
        if delegate != nil {
            delegate?.callOrganisePhone()
        }
    }
    
    @IBAction func siginAction(_ sender: Any) {
        if delegate != nil {
            delegate?.signOrganiseAction()
        }
    }
    
    
    
}
protocol UYOrganiseBottomBarDelegate :NSObjectProtocol {
    func callOrganisePhone()
    func collectOrganiseAction()
    func signOrganiseAction()
}
