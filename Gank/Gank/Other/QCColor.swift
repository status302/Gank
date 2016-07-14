//
//  QCRandomColor.swift
//  Gank
//
//  Created by 程庆春 on 16/7/6.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

extension UIColor {
    func randomColor() -> UIColor {
        let randomRed = CGFloat(Double(arc4random_uniform(255)) / 256.000)

        let randomGreen = CGFloat(Double(arc4random_uniform(255)) / 256.000)
        let randomBlue = CGFloat(Double(arc4random_uniform(255)) / 256.000)

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

    }
}