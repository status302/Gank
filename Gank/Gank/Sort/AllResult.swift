//
//  AllResult.swift
//  Gank
//
//  Created by 程庆春 on 16/8/13.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import RealmSwift

class AllResult: Object {
    dynamic var id: String?
    dynamic var createdAt: String?
    dynamic var desc: String?
    dynamic var publishedAt: String?
    dynamic var source: String?
    dynamic var type: String?
    dynamic var url: String?
    dynamic var used: String?
    dynamic var who: String?
    dynamic var isCollected: Bool = false  /// 收藏标识： 0 --->>> 不收藏， 1 --->>> 收藏

    class func currentAllResult(count: Int) -> [AllResult] {
        let realm = try! Realm()

        let allResults = realm.objects(AllResult).sorted("createdAt", ascending: false)
        
        var resultArr = [AllResult]()
        resultArr.removeAll()

        for (index, result) in allResults.enumerate() {
            if index < count {
                resultArr.append(result)
            } else {
                return resultArr
            }
        }
        return resultArr
    }

    class func parseFromDict(dict: NSDictionary) -> Bool {

        let allID = dict["_id"] as? String
        guard allID != nil else {
            return false
        }
        let createdAt = dict["createdAt"] as? String
        guard createdAt != nil else {
            return false
        }

        let realm = try! Realm()

        let results = realm.objects(AllResult).filter("id == %@ OR createdAt == %@", allID!, createdAt!)

        if results.count > 0 {
            let result = results[0]
            try! realm.write({
                result.id = allID
                result.createdAt = createdAt
                result.desc = dict["desc"] as? String
                result.publishedAt = dict["publishedAt"] as? String
                result.source = dict["source"] as? String
                result.type = dict["type"] as? String
                result.url = dict["url"] as? String
                result.used = dict["url"] as? String
                result.who = dict["who"] as? String
            })
        } else {
            let result = AllResult()
            result.id = allID
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

    class func parseFromArray(array: NSArray) {
        for arr in array {
            if let dict = arr as? NSDictionary {
                AllResult.parseFromDict(dict)
            }
        }
    }

}
