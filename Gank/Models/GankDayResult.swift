//
//  GankDayResult.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import Arrow

struct GankDayJson {
    var error: Bool = false
    var category: [String]?
    var results: [String: GankDayResult]?
}

extension GankDayJson: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        error <-- json["error"]
        category <-- json["category"]
        results <-- json["results"]
    }
}

struct GankDayResult {
    var id: String?
    var createdAt: String?
    var desc: String?
    var publishedAt: String?
    var source: String?
    var type: String?
    var url: String?
    var used: Bool = false
    var who: String?
}

extension GankDayResult: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        id <-- json["_id"]
        createdAt <-- json["createdAt"]
        desc <-- json["desc"]
        publishedAt <-- json["publishedAt"]
        source <-- json["source"]
        type <-- json["type"]
        url <-- json["url"]
        used <-- json["used"]
       who <-- json["who"]
    }
}

