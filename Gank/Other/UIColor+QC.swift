//
//  UIColor+QC.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        let g = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        let b = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}