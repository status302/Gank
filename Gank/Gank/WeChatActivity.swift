//
//  WeChatActivity.swift
//  Gank
//
//  Created by 程庆春 on 16/6/21.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import MonkeyKing


final class WeChatActivity: AnyActivity {
    enum Type {
        case Session
        case Timeline

        var type: String {
            switch self {
            case .Session:
                return Common.WeChat.sessionType
            case .Timeline:
                return Common.WeChat.timeLineType
            }
        }

        var title: String {
            switch self {
            case .Session:
                return Common.WeChat.sessionTitle
            case .Timeline:
                return Common.WeChat.timeLineTitle
            }
        }

        var image: UIImage {
            switch self {
            case .Session:
                return Common.WeChat.sessionImage!
            case .Timeline:
                return Common.WeChat.timeLineImage!
            }
        }
    }

    init(type: Type, message: MonkeyKing.Message, completionHandler: MonkeyKing.SharedCompletionHandler) {
        super.init(type: type.type, title: type.title, image: type.image, message: message, completionHandler: completionHandler)
    }
}

