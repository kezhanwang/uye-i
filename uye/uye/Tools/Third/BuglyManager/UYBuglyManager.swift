//
//  UYBuglyManager.swift
//  uye
//
//  Created by Tintin on 2017/11/10.
//  Copyright © 2017年 BJZT. All rights reserved.
//

import UIKit

class UYBuglyManager: NSObject {
    static func startBugly() {
        Bugly.start(withAppId: "d24215cb88")
    }
}
