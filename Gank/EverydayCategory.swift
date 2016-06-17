//
//  EverydayType.swift
//  Gank
//
//  Created by 程庆春 on 16/6/15.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation

struct EverydayCategory {

    var selectedFlag: Bool?

    var category: String? {
        didSet {
            selectedFlag = false
        }
    }

    
}