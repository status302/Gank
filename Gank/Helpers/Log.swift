//
//  Log.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/1.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

func Log<T>(_ message: T, function: String = #function, line: Int = #line) {
    print(function + "-" + "\(line)" + "-" + "\(message)")
}
