//
//  HomeViewModel.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/3.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import Alamofire
import Arrow

struct HomeViewModel  {
    
    private(set) var dayModel: GankDayModel
    
    init(dayModel: GankDayModel) {
        self.dayModel = dayModel
    }
    
    static func getDayJson(block: ((GankDayModel?) -> Void)?) {
        guard let url = URL.init(string: GankType.today) else { return }
        
        guard let networkManager = NetworkReachabilityManager(),
            networkManager.isReachable else {
                block?(nil)
                return
        }
        
        Alamofire.request(url, method: .get).responseJSON { (response) in
            guard response.result.error == nil else {
                print("some error occur: \(String(describing: response.result.error))")
                return
            }
            
            if let rawValue = response.result.value,
                let json = JSON.init(rawValue) {
                var dayResult = GankDayModel()
                dayResult.deserialize(json)
                block?(dayResult)
            }
        }
    }
}
