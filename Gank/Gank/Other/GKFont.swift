//
//  GKFont.swift
//  Gank
//
//  Created by 程庆春 on 16/7/1.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

extension UIFont {
    internal class func font_lobster(fontName: String = "Lobster1.4", size: CGFloat) -> UIFont? {
        return UIFont(name: fontName, size: size)
    }
    internal class func font_dfphaib(fontName: String = "DFPHaiBaoW12-GB", size: CGFloat) -> UIFont? {
        return UIFont(name: fontName, size: size)
    }
    internal class func font_heart(fontName: String = "ZapfinoExtraLT-Two", size: CGFloat) -> UIFont? {
        return UIFont(name: fontName, size: size)
    }

    internal class func font_roboto_bold(fontName: String = "Roboto-Bold", size: CGFloat) -> UIFont? {
        return UIFont(name: "Roboto-Bold", size: size)
    }
}