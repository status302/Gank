//
//  EveryRootClass.swift
//  Gank
//
//  Created by 程庆春 on 16/6/15.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation

struct EverydayRootClass {
    var error: Bool!

    var results: [String: [EverydayResult]]!
    var categories: [String]!
//    var topics: [EverydayResult]!


    init(fromDictionary dictionary: NSDictionary) {
        error = dictionary["error"] as? Bool
        categories = dictionary["category"] as? [String]
        results = [String: [EverydayResult]]()

        var everyday = [EverydayResult]()
        if let temps = dictionary["results"] as? NSDictionary {
            for category in categories {
                everyday.removeAll()
                if let temp = temps[category] as? [NSDictionary] {
                    for t in temp {
                        everyday.append(EverydayResult(fromDictionary: t))
                    }
                }

                results[category] = everyday            }
        }

    }
}
