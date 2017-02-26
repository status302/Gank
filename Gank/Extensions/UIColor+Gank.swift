//
//  UIColor+Gank.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension UIColor {
    class var gk_random: UIColor {
        let r = CGFloat(Double(arc4random_uniform(256)) / 256.0)
        let g = CGFloat(Double(arc4random_uniform(256)) / 256.0)
        let b = CGFloat(Double(arc4random_uniform(256)) / 256.0)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
