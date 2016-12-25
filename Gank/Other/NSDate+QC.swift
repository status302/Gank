//
//  NSDate+QC.swift
//  Gank
//
//  Created by 程庆春 on 16/6/17.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation

extension NSDate {

    func deltaFromDate(from: NSDate)-> NSDateComponents {
        let currentCalendar = NSCalendar.currentCalendar()
        let unit: NSCalendarUnit = [.Year, .Month, .Day]
        return currentCalendar.components(unit, fromDate: from, toDate: NSDate(), options: .MatchFirst)

    }

}