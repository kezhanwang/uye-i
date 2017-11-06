//
//  UYMessageViewController.swift
//  uye
//
//  Created by Tintin on 2017/11/6.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYMessageViewController: UYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "消息"
    }
    override func setupUI() {
        setupErrorView(image: "order_empty_icon", title: "暂时无新消息")
    }
}
