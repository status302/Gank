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


class AlamofireManager {
    typealias CompletedHandler = (rootClass: RootClass?)->Void


    // 创建一个单例
    static let sharedInstance = AlamofireManager()


    var urlStr: String = ""
    var testUrlStr = "http://gank.io/api/data/Android/10/1"
    

    var type: URLType? {
        didSet {
            urlStr = "http://gank.io/api/data/" + type!.rawValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "/\(Common.countOnePage)/\(page)"
            testUrlStr = "http://gank.io/api/data/Android/10/1"
        }
    }

    var page: Int = 1 {
        didSet {
            urlStr = "http://gank.io/api/data/" + type!.rawValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "/\(Common.countOnePage)/" + "\(page)"
        }
    }

    var alamofireNetworkReachablityManager = NetworkReachabilityManager()

    func fetchDataForWelfare(completedHandler: CompletedHandler) {

        let requestResult = Alamofire.request(.GET, self.urlStr, parameters: nil, encoding: .URL, headers: nil)
        requestResult.responseJSON { (response) in
            guard let json = response.result.value else {
                print("\(response.debugDescription)")
                completedHandler(rootClass: nil)
                return
            }
            // 处理json
            let model = RootClass(fromDictionary: json as! NSDictionary)
            completedHandler(rootClass: model)

        }
    }

    /**
     网络请求

     - parameter completedHandler: 得到数据后待处理的闭包。root: 包含数据的RootClass的实例
     */
    func fectchTopicData(urlString: String, completedHandler: CompletedHandler) {
        let dataRequest = Alamofire.request(.GET, urlString, parameters: nil, encoding: .URL, headers: nil)

        dataRequest.responseJSON { (response) in
            guard let json = response.result.value else {
                print("error occurs")
                completedHandler(rootClass: nil)
                return
            }

            let modal = RootClass(fromDictionary: json as! NSDictionary)
            completedHandler(rootClass: modal)
        }
    }

}

protocol FetchSortResultdelegate {
    func fetchSuccess()
    func fetchFalied()
}
class SortNetWorkManager: NSObject {
    static let sortNetwordSharedInstance = SortNetWorkManager()

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