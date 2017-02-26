//
//  DispatchQueue+Gank.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension DispatchQueue {
    class func safeMainQueue(block: @escaping (Void) -> Void) {
        if Thread.isMainThread {
            block()
        }
        else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
