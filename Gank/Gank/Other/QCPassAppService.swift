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
    func getPassAppStoreService() {
        Alamofire.request(.GET, "http://qiuncheng.com/app.html").responseString { (response) in

        }
    }

}
