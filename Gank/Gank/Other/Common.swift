//
//  Common.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

struct Common {
    static let Screen_width = UIScreen.mainScreen().bounds.size.width
    static let Screen_height = UIScreen.mainScreen().bounds.size.height

    static let everydayGankCellID = "everydayGankCellID"

    // MARK: - WealfareVC
    static let welfareCellID = "WelfareCollectionViewCellID"


    // MARK: - CollectionView Layout
    static let CollectionViewLayoutColumnCount: Int = 3
    static let CollectionViewLayoutColumnMargin: CGFloat = 10.0
    static let CollectionViewLayoutRowMargin: CGFloat = 10.0
    static let CollectionViewLayoutEdgeInsets = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 0.0, right: 8.0)
    static let CollectionViewLayoutCellHeight: CGFloat = Common.Screen_height - 160.0
    static let CollectionViewLayoutCellWidth: CGFloat = Common.Screen_width - 80.0

}

extension Common {
    static let navigationBarBackgroundColor = UIColor(red: 255/255, green: 224/255, blue: 102/255, alpha: 1.0)
    static let globalBackgroundColor = UIColor.greenColor()
}

extension Common {
    static let countOnePage:Int = 15
}
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

}

//
enum URLType: String{
    case welfare = "福利"
    case android = "Android"
    case iOS = "iOS"
    case App = "App"
    case sleep = "休息视频"
    case resourse = "拓展资源"
    case front_end = "前端"
    case all = "all"

}

