//
//  AlamofireManager.swift
//  Gank
//
//  Created by 程庆春 on 16/5/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation
import Alamofire
import PKHUD
import SwiftyJSON


class DayNetworkService: NSObject {
    typealias CompletedHandler = Bool -> Void
    static let dayManager = DayNetworkService()

    var isReachable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    func fetchDayData(url: String, completedHandler: CompletedHandler) {
        let status = NetworkReachabilityManager()!.isReachable
        if !status {
            completedHandler(false)
        }
        let request = Alamofire.request(.GET, url)
        request.responseJSON { (response) in

            guard let data = response.data else {
                completedHandler(false)
                return
            }
            let json = JSON(data: data)
            DayResult.parseFromDict(json.dictionaryValue, fUrl: url)
            completedHandler(true)
        }
    }
}

protocol FetchSortResultdelegate {
    func fetchSuccess()
    func fetchFalied()
}
class SortNetWorkManager: NSObject {
    static let sortNetwordSharedInstance = SortNetWorkManager()

    var isRechalble: Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    typealias CompletedHandler = Bool -> Void

    var delegate: FetchSortResultdelegate?
    /**
     *  sort data
     */
    func fetchSortData(type: URLType, page:Int, completed: CompletedHandler) {
        let status = NetworkReachabilityManager()?.isReachable
        if status == false {
            delegate?.fetchFalied()
            completed(false)
            return
        }

        let urlString = Common.URL.baseURL + "/data/" + type.rawValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "/12/\(page)"
        let request = Alamofire.request(.GET, urlString)

        request.responseJSON { (response) in

            guard let data = response.data else {
                self.delegate?.fetchFalied()
                completed(false)
                return
            }


            let json = JSON(data: data)

            if let error = json["error"].bool {
                if error == true {
                    self.delegate?.fetchFalied()
                    completed(false)
                    return
                }
            }

            if type.rawValue == "all" {
                if let allRoot = response.result.value as? NSDictionary{

                    if let results = allRoot["results"] as? NSArray {
//                        SortResult.parseFromArray(results)
                        AllResult.parseFromArray(results)
                    }
                    completed(true)
                    self.delegate?.fetchSuccess()
                } else {
                    self.delegate?.fetchFalied()
                    completed(false)
                    return
                }
            }
            if let root = response.result.value as? NSDictionary{

                if let results = root["results"] as? NSArray {
                    SortResult.parseFromArray(results)
                }
                completed(true)
                self.delegate?.fetchSuccess()
            } else {
                self.delegate?.fetchFalied()
                completed(false)
                return
            }
        }
    }

}