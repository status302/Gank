//
//  GKApp.swift
//  Gank
//
//  Created by 程庆春 on 16/8/31.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

struct GKApp {

    static let appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"]
    static let appVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    static let appBuildVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"]
}
