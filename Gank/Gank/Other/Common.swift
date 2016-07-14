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


    // MARK: - headScrollViewButtonScaleRate
    static let headScrollViewButtonScaleRate: CGFloat = 1.111
    static let headScrollViewButtonTitleFontSize: CGFloat = 16

    // urls 
     static let manImageURLs = ["http://7xk67j.com1.z0.glb.clouddn.com/images%20%281%29.jpeg", "http://7xk67j.com1.z0.glb.clouddn.com/images.jpeg", "http://7xk67j.com1.z0.glb.clouddn.com/Daniel-Wu-2.jpg", "http://7xk67j.com1.z0.glb.clouddn.com/Daniel-Wu-Whos-Dated-Who.jpg"]

    static func getRandomUrl(index: Int) -> NSURL? {
//        let randomNumber = Int(arc4random_uniform(4))
        return NSURL(string: manImageURLs[index])
    }

}

extension Common {
    static let navigationBarBackgroundColor = UIColor(red: 255/255, green: 224/255, blue: 102/255, alpha: 1.0)
    static let globalBackgroundColor = UIColor.greenColor()
}

extension Common {
    static let countOnePage:Int = 15
}

extension Common {
    struct WeChat {
        
        internal static let appID = "wx9b0a6ed257333cd6"
        internal static let sessionType = "com.qiuncheng.gank.io.wechatSession"
        internal static let sessionTitle = NSLocalizedString("微信好友", comment: "")
        internal static let sessionImage = UIImage(named: "wechat_session")

        internal static let timeLineType = "com.qiuncheng.gank.io.wechatTimeline"
        internal static let timeLineTitle = NSLocalizedString("微信朋友圈", comment: "")
        internal static let timeLineImage = UIImage(named: "wechat_timeline")
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

extension Common {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
