//
//  Date+Gank.swift
//  Gank
//
//  Created by yolo on 2017/3/9.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension Date {
    var today: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh-Hant_HK_POSIX@collation=pinyin;currency=CNY")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }
    
    var yesterday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh-Hant_HK_POSIX@collation=pinyin;currency=CNY")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self.addingTimeInterval(-24 * 60 * 60))
    }
}
