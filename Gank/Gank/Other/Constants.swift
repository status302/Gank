//
//  Constants.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

struct Constants {
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
    static let CollectionViewLayoutCellHeight: CGFloat = Constants.Screen_height - 160.0
    static let CollectionViewLayoutCellWidth: CGFloat = Constants.Screen_width - 80.0

    static let backgroundColor = UIColor.orangeColor()
}

//
enum URLType: String{
    case welfare = "福利"
    case android = "Android"
    case iOS = "iOS"
    case sleep = "休息视频"
    case resourse = "拓展资源"
    case front_end = "前端"
    case all = "all"

}

