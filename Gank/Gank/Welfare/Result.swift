//
//  Result.swift
//  Gank
//
//  Created by 程庆春 on 16/5/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

struct Result {

    var id: String!
    var createdAt: String!
    var desc: String!
    var publishedAt: String!
    var source: String!
    var type: String!
    var url: String!
    var used: Bool!
    var who: String!

    var page: Int!


    /**
        Heights
     */

    var descLabelHeight: CGFloat!
    var timeLabelHeight: CGFloat!
    var cellHeight: CGFloat!

    var publishedString: String!

    init(fromDictionary dictionary: NSDictionary) {

        id = dictionary["_id"] as? String
        createdAt = dictionary["createdAt"] as? String ?? ""
        desc = dictionary["desc"] as? String
        publishedAt = dictionary["publishedAt"] as? String ?? ""
        source = dictionary["source"] as? String
        type = dictionary["type"] as? String
        url = dictionary["url"] as? String
        used = dictionary["used"] as? Bool
        who = dictionary["who"] as? String ?? "daimajia"
        page = 1


        descLabelHeight = stringToSize(14, str: desc as NSString).height
        timeLabelHeight = stringToSize(10, str: publishedAt as NSString).height
        cellHeight = descLabelHeight + timeLabelHeight + 30


        publishedString = self.dateToString(publishedAt)
    }


    private func dateToString(dateStr: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
        let newDate = formatter.dateFromString(dateStr)

        let formatter2 = NSDateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd"

        let newDateStr: String = formatter2.stringFromDate(newDate!)

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

    private func stringToSize(fontSize: CGFloat, str: NSString)-> CGSize {
        let height = CGFloat.max
        let width = Common.Screen_width - 50.0
        let size = str.boundingRectWithSize(CGSize(width: width, height: height), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(fontSize)], context: nil).size
        return size
    }
}