//
//  AlamofireManager.swift
//  Gank
//
//  Created by 程庆春 on 16/5/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireManager {
    typealias CompletedHandler = (rootClass: RootClass?)->Void

    static let sharedInstance = AlamofireManager()


    func fetchDataForWelfare(completedHandler: CompletedHandler) {
        var strURL = "http://gank.io/api/data/福利/10/2"
//        strURL = strURL.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        strURL = strURL.stringByRemovingPercentEncoding!
        print(strURL)

        let requestResult = Alamofire.request(.GET, strURL, parameters: nil, encoding: .URL, headers: nil)
        requestResult.responseJSON { (response) in
            guard let json = response.result.value else {
                print("error occur")
                completedHandler(rootClass: nil)
                return
            }

            // 处理json
            let model = RootClass(fromDictionary: json as! NSDictionary)
            completedHandler(rootClass: model)
        }
    }
}
