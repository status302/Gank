//
//  QCPassAppService.swift
//  Gank
//
//  Created by 程庆春 on 16/7/30.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation
import Alamofire

class QCPassAppService: NSObject {

    static let sharedInstance = QCPassAppService()
    var networkReachable: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    func getPassAppStoreService() {
        guard networkReachable == false else { return }
        if let url = NSURL(string: "http://simapps.cn/php/index/cqcapi.html") {
            do {
                var passed: NSString = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
                if passed.containsString("\n") {
                    passed = passed.substringToIndex(1)
                }
                QCUserDefault.setPassed(passed)
            } catch let e{
                print("\(e)")
            }
        }
    }

}
