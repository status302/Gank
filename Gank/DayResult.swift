//
//  DayResult.swift
//  Gank
//
//  Created by 程庆春 on 16/8/14.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class DayResult: Object {
    dynamic var url: String?
    var category = List<CategoryType>()
    dynamic var error: Bool = false
    var results = List<CategoryResult>()

    class func currentDayResult(url: String) -> DayResult? {
        let realm = try! Realm()

        let dayResults = realm.objects(DayResult).filter("url == %@", url)

        return dayResults.first
    }

    class func currentDayResultCategory(url: String) -> [String: [CategoryResult]]? {
        guard let dayResult = self.currentDayResult(url) else {
            return nil
        }

        var returnResult = [String: [CategoryResult]]()
        let categories = dayResult.category

        for category in categories {

            var crs = [CategoryResult]()

            for result in dayResult.results {
                if result.type == category.type {
                    crs.append(result)
                }

            }
            returnResult[category.type!] = crs
        }
        return returnResult
    }


    class func parseFromDict(dict: [String : JSON], fUrl: String?) {//-> Bool {
        let url = fUrl
        guard url != nil else { print("invalid url");  return  }

        if dict == [:] {
            return
        }
        let realm = try! Realm()

        let dayResults = realm.objects(DayResult).filter("url == %@", url!)
        if dayResults.count > 0 {
            let dayResult = dayResults.first!

            try! realm.write({
                dayResult.url = url
//                dayResult.error = (dict["error"]?.bool)!

                let categories = List<CategoryType>()
                for category in (dict["category"]?.arrayValue)! {
                    let cat = CategoryType()
                    cat.type = category.string
                    categories.append(cat)
                }
                dayResult.category = categories

                let mResults = List<CategoryResult>()

                let typeDict = dict["results"]?.dictionaryValue

                for category in (dict["category"]?.arrayValue)! {
                    let results = self.parseFromType(typeDict!, type: category.string!)
                    for result in results {
                        mResults.append(result)
                    }
                }
                dayResult.results = mResults
            })
        } else {
            let dayResult = DayResult()

//            dayResult.error = dict["error"]!.bool!
            dayResult.url = url

            let typeDict = dict["results"]?.dictionaryValue

            let mResults = List<CategoryResult>()

            let categories = List<CategoryType>()
            for category in dict["category"]!.arrayValue {
                let cr = CategoryType()
                cr.type = category.string
                categories.append(cr)
                let results = self.parseFromType(typeDict!, type: category.string!)
                for result in results {
                    mResults.append(result)
                }
            }
            dayResult.category = categories
            dayResult.results = mResults

            try! realm.write({
                realm.add(dayResult)
            })
        }
    }


    class func parseFromType(dict: [String: JSON] ,type: String) -> List<CategoryResult> {
        let mResults = List<CategoryResult>()
        if let array = dict[type]?.arrayValue {
            for arr in array {
                let cr = CategoryResult()
                cr.id = arr.dictionaryValue["_id"]?.string
                cr.desc = arr.dictionaryValue["desc"]?.string
                cr.createdAt = arr.dictionaryValue["createdAt"]?.string
                cr.url = arr.dictionaryValue["url"]?.string
                cr.type = arr.dictionaryValue["type"]?.string
                cr.publishedAt = arr.dictionaryValue["publishedAt"]?.string
                cr.used = arr.dictionaryValue["used"]!.bool!
                cr.who = arr.dictionaryValue["who"]?.string
                mResults.append(cr)
            }
        }
        return mResults
    }
}

class CategoryType: Object {
    dynamic var type: String?
}

class CategoryResult: Object {

    dynamic var id: String?
    dynamic var createdAt: String?
    dynamic var desc: String?
    dynamic var publishedAt: String?
    dynamic var type: String?
    dynamic var url: String?
    dynamic var used: Bool = false
    dynamic var who: String?
}
