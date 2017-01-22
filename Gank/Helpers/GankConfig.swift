//
//  GankConfig.swift
//  Gank
//
//  Created by yolo on 2017/1/22.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import Foundation

protocol GankConfigable {
    var pageCount: Int { get }
}


struct GankConfig {
    static let imageCacheName = "/gank_home_images_path"
    static let imageCacheKey = GankConfig.imageUrlString!
    static var imageUrlString: String? {
        if let baseUrl = GankType.welfare.urlBaseString {
            return "\(baseUrl)6/1"
        }
        else {
            return nil
        }
    }
}
