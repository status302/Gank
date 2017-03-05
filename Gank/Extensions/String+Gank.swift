//
//  String+Gank.swift
//  Gank
//
//  Created by yolo on 2017/3/5.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension String {
    func boundsWidth(font: UIFont, height: CGFloat) -> CGFloat{
        return self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil).width
    }
}
