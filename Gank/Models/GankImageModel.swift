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

        let imageCacheHelper = CacheHelper(type: .forImage)
        let diskCache = imageCacheHelper.imageCache()
        cacheQueue.async {
            if let object = diskCache.object(forKey: GankConfig.imageCacheKey)            {
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
        
        guard let urlString = GankConfig.imageUrlString,
            let url = URL.init(string: urlString) else {
            block(nil)
            return
        }
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
                        diskCache.setObject(json as? NSDictionary, forKey: GankConfig.imageCacheKey)
                    })
                }
                else {
                    block(nil)
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


