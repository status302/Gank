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
import YYCache

struct GankImageModel {
    var error: Bool?
    var results: Array<GankResult>? //"http://gank.io/api/data/%E7%A6%8F%E5%88%A9/10/1"

    static func fetchImages(gankType: GankType ,block:@escaping ((GankImageModel?) -> Void)) {
        let cacheQueue = DispatchQueue(label: "gank_cache_image_queue_label", qos: .default)
        let networkManager = NetworkReachabilityManager()
        
        let diskCache: YYDiskCache?
        if let cacheFolderString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            let path = cacheFolderString + GankConfig.imageCacheName
            diskCache = YYDiskCache(path: path)
        }
        else {
            diskCache = nil
        }
        cacheQueue.async {
            let object = diskCache?.object(forKey: GankConfig.imageCacheKey)
            if object != nil {
                var jsons = GankImageModel()
                if let jsonData = JSON(object) {
                    jsons.deserialize(jsonData)
                    block(jsons)
                }
            }
        }
        if !networkManager!.isReachable {
            return
        }
        
        guard let urlString = GankConfig.imageUrlString else {
            block(nil)
            return
        }
        
        if let url = URL(string: urlString) {
            Alamofire.request(url, method: .get).responseJSON { (response) in
                guard response.result.error == nil else {
                    print("\(response.result.error)")
                    block(nil)
                    return
                }
                
                if let json = response.result.value {
                    var jsons = GankImageModel()
                    if let jsonData = JSON(json) {
                        jsons.deserialize(jsonData)
                        block(jsons)
                        cacheQueue.async(execute: {
                            diskCache?.setObject(json as? NSDictionary, forKey: GankConfig.imageCacheKey)
                        })
                    }
                    else {
                        block(nil)
                    }
                }
            }
        }
    }
}

extension GankImageModel: ArrowParsable {
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
