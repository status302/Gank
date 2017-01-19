//
//  MeiziImageModel.swift
//  Gank
//
//  Created by yolo on 2017/1/19.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import Foundation
import Alamofire
import YYModel

class GankJson: NSObject {
    var error: Bool?
    var results: [GankResult]? //"http://gank.io/api/data/%E7%A6%8F%E5%88%A9/10/1"
    
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
                if let json = response.result.value as? [String: Any]{
                    let jsons = GankJson.yy_model(withJSON: json)
                    block(jsons)
                }
            }
        }
    }
}

class GankResult: NSObject {
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
