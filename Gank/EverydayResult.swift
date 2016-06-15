//
//  EverydayResult.swift
//  Gank
//
//  Created by 程庆春 on 16/6/15.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation

struct EverydayResult {
    
    var id: String!
    var createAt: String!
    var desc: String!
    var publishedAt: String!
    var type: String!
    var url: String!
    var used: Bool!
    var who: String!

    init(fromDictionary dictionary: NSDictionary) {
        id = dictionary["_id"] as? String
        createAt = dictionary["createAt"] as? String
        desc = dictionary["desc"] as? String
        publishedAt = dictionary["publishedAt"] as? String
        type = dictionary["type"] as? String
        url = dictionary["url"] as? String
        used = dictionary["used"] as? Bool
        who = dictionary["who"] as? String

    }

    
}
