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
        let strURL = "http://gank.io/api/data/%E7%A6%8F%E5%88%A9/20/1"
//        print(strURL)

/*
        do {
            let strResult = try NSString(contentsOfURL: NSURL(string: strURL)!, encoding: NSUTF8StringEncoding)
            let data = strResult.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                let model = RootClass(fromDictionary: json as! NSDictionary)
                completedHandler(rootClass: model)
            } catch {
                print("json has some error")
            }
        } catch {
            print("error occur")
        }
*/
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
