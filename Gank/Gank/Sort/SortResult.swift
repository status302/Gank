//
//  SortResult.swift
//  Gank
//
//  Created by 程庆春 on 16/8/6.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import RealmSwift

class SortResult: Object {
    dynamic var id: String?
    dynamic var createdAt: String?
    dynamic var desc: String?
    dynamic var publishedAt: String?
    dynamic var source: String?
    dynamic var type: String?
    dynamic var url: String?
    dynamic var used: String?
    dynamic var who: String?


    class func currentResult(count: Int ,type: String) -> [SortResult]{
        let realm = try! Realm()

        let results = realm.objects(SortResult).filter("type == %@", type).sorted("publishedAt", ascending: false)

        var resultArr = [SortResult]()
        
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

        let results = realm.objects(SortResult).filter("id == %@ OR createdAt == %@", id!, createdAt!)

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

            })
        } else {
            let result = SortResult()

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
                SortResult.parseFromDict(dict)
            }
        }
        return true
    }
}
