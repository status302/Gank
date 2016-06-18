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

class AlamofireManager {
    typealias CompletedHandler = (rootClass: RootClass?)->Void

    static let sharedInstance = AlamofireManager()

    var urlStr: String = ""

    var type: URLType? {
        didSet {
            urlStr = "http://gank.io/api/data/" + type!.rawValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "/20/1"
        }
    }

    var page: Int = 1 {
        didSet {
            urlStr = "http://gank.io/api/data/" + type!.rawValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "/20/" + "\(page)"
        }
    }


    func fetchDataForWelfare(completedHandler: CompletedHandler) {

        HUD.flash(.LabeledProgress(title: "", subtitle: "正在玩命加载ing"))
        let requestResult = Alamofire.request(.GET, self.urlStr, parameters: nil, encoding: .URL, headers: nil)
        requestResult.responseJSON { (response) in
            guard let json = response.result.value else {
                print("error occur")
                completedHandler(rootClass: nil)
                return
            }

            // 处理json
            let model = RootClass(fromDictionary: json as! NSDictionary)
            completedHandler(rootClass: model)
            HUD.hide()
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
