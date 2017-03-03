//
//  CacheHelper.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import YYCache

enum GankCacheType {
    case forImage
    case forHomeResult
}

extension GankCacheType {
    var cachePath: String? {
        switch self {
        case .forImage:
            if let cacheFolderString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
                return cacheFolderString + "/gank_home_images_path"
            }
            else {
                return nil
            }
        case .forHomeResult:
            if let cacheFolderString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
                return cacheFolderString + "/gank_home_result_path"
            }
            else {
                return nil
            }
        }
    }
}

struct CacheHelper {

    private(set) var cacheType : GankCacheType

    init(type: GankCacheType) {
        self.cacheType = type
    }

    func imageCache() -> YYDiskCache {
        guard let path = cacheType.cachePath else { fatalError("无法获取到该cachePath : \(cacheType)") }
        guard let imageCache = YYDiskCache.init(path: path) else { fatalError("该地址获取不到cache : \(path)") }

        imageCache.ageLimit = TimeInterval(7 * 24 * 60 * 60) /// 7 天
        imageCache.autoTrimInterval = TimeInterval(7 * 24 * 60 * 60) /// 7 天
        imageCache.costLimit = UInt(20 * 1024 * 1024) /// 20 
        return imageCache
    }
}
