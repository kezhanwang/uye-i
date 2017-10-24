//
//  UYSearchBarView.swift
//  uye
//
//  Created by Tintin on 2017/10/22.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYSearchBarView: UIView {
    var searchBar = UISearchBar()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchBar)
        backgroundColor = UIColor.randomColor
        
        for view in searchBar.subviews {
            for subView in view.subviews {
                if subView.isKind(of: UITextField.classForCoder()) {
                    let  searchField:UITextField = subView as! UITextField
                    searchField.backgroundColor = UIColor.lightBackground
                    searchField.font = UIFont.systemFont(ofSize: 15)
                }
            }
        }
        
        searchBar.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(0)
            make.left.equalTo(16)
            make.right.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }

}
