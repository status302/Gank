//
//  ServiceResult.swift
//  Gank
//
//  Created by yolo on 2017/3/10.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

enum ServiceResult<T> {
    case successed(T)
    case failed
}
