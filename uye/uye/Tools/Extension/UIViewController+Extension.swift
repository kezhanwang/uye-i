//
//  UIViewController+Extension.swift
//  uye
//
//  Created by Tintin on 2017/10/15.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

extension  UIViewController {
    var safeAreaHeight : CGFloat {
        let ory = navigationController!.navigationBar.frame.height + navigationController!.navigationBar.frame.origin.y
        return ory
    }
}
