//
//  Result.swift
//  Gank
//
//  Created by 程庆春 on 16/5/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation

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


    init(fromDictionary dictionary: NSDictionary) {

        id = dictionary["_id"] as? String
        createdAt = dictionary["createdAt"] as? String
        desc = dictionary["desc"] as? String
        publishedAt = dictionary["publishedAt"] as? String
        source = dictionary["source"] as? String
        type = dictionary["type"] as? String
        url = dictionary["url"] as? String
        used = dictionary["used"] as? Bool
        who = dictionary["who"] as? String

        page = 1
    }
}