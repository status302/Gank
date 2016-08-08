//
//  SortAllResult.swift
//  Gank
//
//  Created by 程庆春 on 16/8/7.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import RealmSwift

class SortAllResult: Object {
    dynamic var id: String?
    dynamic var createdAt: String?
    dynamic var desc: String?
    dynamic var publishedAt: String?
    dynamic var source: String?
    dynamic var type: String?
    dynamic var url: String?
    dynamic var used: String?
    dynamic var who: String?
    dynamic var cellHeight: Float = 0.0


    class func currentResult(count: Int ,type: String) -> [SortAllResult]{
        let realm = try! Realm()

        let results = realm.objects(SortAllResult).sorted("publishedAt", ascending: false)

        var resultArr = [SortAllResult]()

        for (index, result) in results.enumerate() {
            if index > (count - 1) {
                return resultArr
            }
            resultArr.append(result)
        }
        return resultArr
    }


    class func parseFromDict(dict: NSDictionary) -> Bool{
        let id = dict["_id"] as? String
        guard id != nil else {
            return false
        }
        let createdAt = dict["createdAt"] as? String
        guard createdAt != nil else {
            return false
        }

        let realm = try! Realm()

        let results = realm.objects(SortAllResult).filter("id == %@ OR createdAt == %@", id!, createdAt!)

        if results.count > 0 {
            let result = results[0]

            try! realm.write({
                result.id = id
                result.createdAt = createdAt
                result.desc = dict["desc"] as? String
                result.publishedAt = dict["publishedAt"] as? String
                result.source = dict["source"] as? String
                result.type = dict["type"] as? String
                result.url = dict["url"] as? String
                result.used = dict["url"] as? String
                result.who = dict["who"] as? String

                let descLabelHeight = SortAllResult.stringToSize(14, str: result.desc! as NSString).height
                let timeLabelHeight = SortAllResult.stringToSize(10, str: result.publishedAt! as NSString).height
                result.cellHeight = Float(descLabelHeight) + Float(timeLabelHeight) + 30

            })
        } else {
            let result = SortAllResult()

            result.id = id
            result.createdAt = createdAt
            result.desc = dict["desc"] as? String
            result.publishedAt = dict["publishedAt"] as? String
            result.source = dict["source"] as? String
            result.type = dict["type"] as? String
            result.url = dict["url"] as? String
            result.used = dict["url"] as? String
            result.who = dict["who"] as? String

            try! realm.write({
                realm.add(result)
            })
        }
        return true
    }

    class func parseFromArray(arrs: NSArray) -> Bool {
        for dict in arrs {
            if let dict = dict as? NSDictionary {
                SortAllResult.parseFromDict(dict)
            }
        }
        return true
    }

    // date
    internal func dateToString(dateStr: String) -> String {

        ///  "publishedAt": "2016-06-16T12:19:00.930Z"

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
        let newDate = formatter.dateFromString(dateStr)
        let formatter2 = NSDateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd"

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

    class func stringToSize(fontSize: CGFloat, str: NSString)-> CGSize {
        let height = CGFloat.max
        let width = Common.Screen_width - 50.0
        let size = str.boundingRectWithSize(CGSize(width: width, height: height), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(fontSize)], context: nil).size
        return size
    }
}