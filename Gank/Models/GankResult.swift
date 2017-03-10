//
//  GankResult.swift
//  Gank
//
//  Created by yolo on 2017/2/2.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import Foundation
import Arrow

struct GankResult {
    var id: String = ""
    var createdAt: String = ""
    var desc: String = ""
    var publishedAt: String = ""
    var source: String = ""
    var type: String = ""
    var url: String?
    var used: Bool = false
    var who: String = ""
    var images: [String]?
}

extension GankResult: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        id <-- json["_id"]
        createdAt <-- json["createdAt"]//?.dateFormat("yyyy-MM-dd'T'HH:mm:ss.ZZZZ")
        desc <-- json["desc"]
        publishedAt <-- json["publishedAt"]//?.dateFormat("yyyy-MM-dd'T'HH:mm:ss.ZZZZ")
        source <-- json["source"]
        type <-- json["type"]
        url <-- json["url"]
        used <-- json["used"]
        who <-- json["who"]
        images <-- json["images"]
    }
}
