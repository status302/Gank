//
//  WelfarreModel.swift
//  Gank
//
//  Created by 程庆春 on 16/5/23.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

struct Welfare {
    
     /// the url of meizi image
    var imageUrl: String?
    /// the width of meizi image
    var imageWidth: CGFloat?
    /// the height of meizi image
    var imageHeight: CGFloat?

    /// who deploy this image
    var who: String?

    var page: Int = 0

    var welfareCount: Int = 10

    // http://gank.io/api/data/福利/10/1
    /// welfare url 
//    static var welfareURL: String {
//
//        get {
//            return "http://gank.io/api/data/福利/"+"\(welfareCount)"+"/"+"\(page)"
//        }
//    }
}
extension Welfare {
//    static func getURl() -> String {
//        return "http://gank.io/api/data/福利/"+"\(welfareCount)"+"/"+"\(page)"
//    }
}


