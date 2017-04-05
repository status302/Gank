//
//  GankDayResult.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import Alamofire
import Arrow

struct GankDayModel {
    var error: Bool = false
    var category: [String]?
    var results: GankDaySubModel?
    
    static func getTodayResult(url: String?, block: ((GankDayModel?) -> Void)?) {
        guard let urlStr = url,
            let url = URL(string: urlBaseStringForToday + urlStr) else {
                return
        }
        
        guard let networkManager = NetworkReachabilityManager(),
            networkManager.isReachable else {
                DispatchQueue.safeMainQueue {
                    block?(nil)
                }
                return
        }
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            guard response.result.error == nil else {
                print("some error occur: \(response.result.error)")
                return
            }
            
            if let rawValue = response.result.value,
                let json = JSON.init(rawValue) {
                var dayResult = GankDayModel()
                dayResult.deserialize(json)
                DispatchQueue.safeMainQueue {
                    block?(dayResult)
                }
            }
        }
    }
}

extension GankDayModel: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        error <-- json["error"]
        category <-- json["category"]
        results <-- json["results"]
    }
}

struct GankDaySubModel {
    var android: Array<GankResult>?
    var ios: Array<GankResult>?
    var frontEnd: Array<GankResult>?
    var welfare: Array<GankResult>?
    var video: Array<GankResult>?
    var resource: Array<GankResult>?
    var others: Array<GankResult>?
}

extension GankDaySubModel: ArrowParsable {
    /// The method you declare your JSON mapping in.
    public mutating func deserialize(_ json: JSON) {
        android <-- json["Android"]
        ios <-- json["iOS"]
        frontEnd <-- json["前端"]
        welfare <-- json["福利"]
        video <-- json["休息视频"]
        resource <-- json["拓展资源"]
        others <-- json["瞎推荐"]
    }   
}

