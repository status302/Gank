//
//  EverydayResult.swift
//  Gank
//
//  Created by 程庆春 on 16/6/15.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

struct EverydayResult {
    
    var id: String!
    var createAt: String!
    var desc: String!
    var publishedAt: String!
    var type: String!
    var url: String!
    var used: Bool!
    var who: String!

    var desHeight: CGFloat!
    var timeHeight: CGFloat!
    var cellHeight: CGFloat!
    var publishedTime: String!

    init(fromDictionary dictionary: NSDictionary) {
        id = dictionary["_id"] as? String
        createAt = dictionary["createAt"] as? String
        desc = dictionary["desc"] as? String
        publishedAt = dictionary["publishedAt"] as? String
        type = dictionary["type"] as? String
        url = dictionary["url"] as? String
        used = dictionary["used"] as? Bool
        who = dictionary["who"] as? String


         /// 设置时间
        publishedTime = dateToString(publishedAt)

        /// 设置字符的高度
        let width = Common.Screen_width - 50
        let height = CGFloat.max
        let size = (desc as NSString).boundingRectWithSize(CGSize(width: width, height: height), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12)], context: nil).size

        desHeight = size.height

        let timeSize = (publishedAt as NSString).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(10)], context: nil).size

        timeHeight = timeSize.height

        cellHeight = timeHeight + desHeight + 15
    }

    //处理日期显示
    func dateToString(dateStr: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
        let newDate = formatter.dateFromString(dateStr)

        let formatter2 = NSDateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd"

        /// 避免nil
        guard let new = newDate else {
            return dateStr
        }

        let newDateStr: String = formatter2.stringFromDate(new)

        let components = NSDate().deltaFromDate(newDate!)
        if components.year == 0 {
            if components.month == 0 {
                if components.day == 0 {
                    return "今天"
                } else if components.day == 1 {
                    return "昨天"
                } else if components.day == 2 {
                    return "前天"
                } else {
                    return "\(components.day)天前"
                }
            }
        }
        return newDateStr

    }

    
}
