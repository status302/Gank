//
//  RootClass.swift
//  Gank
//
//  Created by 程庆春 on 16/5/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation

struct RootClass {
    var error: Bool!
    var results: [Result]!



    init(fromDictionary dictionary: NSDictionary) {
        error = dictionary["error"] as? Bool
        results = [Result]()
        if let resultArray = dictionary["results"] as? [NSDictionary] {
            for dict in resultArray {
                let value = Result(fromDictionary: dict)
                results.append(value)
            }
        }

    }
}
