//
//  MeiziImageModel.swift
//  Gank
//
//  Created by yolo on 2017/1/19.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import Foundation
import Alamofire
import Arrow

struct GankJson {
    var error: Bool?
    var results: Array<GankResult>? //"http://gank.io/api/data/%E7%A6%8F%E5%88%A9/10/1"
    
    static func fetchImages(gankType: GankType ,block:@escaping ((GankJson?) -> Void)) {
        guard let baseUrl = gankType.urlBaseString else {
            block(nil)
            return
        }
        
        if let url = URL(string: "\(baseUrl)10/1") {
            Alamofire.request(url, method: .get).responseJSON { (response) in
                guard response.result.error == nil else {
                    block(nil)
                    return
                }
                
                guard response.result.isSuccess else {
                    block(nil)
                    return
                }
                
                if let json = response.result.value {
                    var jsons = GankJson()
                    if let jsonData = JSON(json) {
                        jsons.deserialize(jsonData)
                        block(jsons)
                    }
                    else {
                        block(nil)
                    }
                }
            }
        }
    }
}

extension GankJson: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        error <-- json["error"]
        results <-- json["results"]
    }
}

struct GankResult {
    var id: String?
    var createdAt: String?
    var desc: String?
    var publishedAt: String?
    var source: String?
    var type: String?
    var url: String?
    var used: Bool?
    var who: String?
    
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["id": "_id"]
    }
}

extension GankResult: ArrowParsable {
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
