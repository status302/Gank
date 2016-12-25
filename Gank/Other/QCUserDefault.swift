//
//  QCUserDefault.swift
//  Gank
//
//  Created by 程庆春 on 16/8/29.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

struct QCUserDefault {

    static let passed: NSString? = {
        return NSUserDefaults.standardUserDefaults().valueForKey(GKKeyValue.kPassed) as? NSString
    }()

    static func setPassed(str: NSString) {
        NSUserDefaults.standardUserDefaults().setValue(str, forKey: GKKeyValue.kPassed)

        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

struct GKKeyValue {
    static let kPassed = "kPassed"
}
