//
//  GKType.swift
//  Gank
//
//  Created by yolo on 2017/1/19.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import Foundation

enum GankType: String {
    case android = "Android"
    case iOS = "iOS"
    case welfare = "福利"
    case frontEnd = "前端"
    case video = "休息视频"
    case resource = "扩展资源"
    case other = "瞎推荐"
    case all = "all"
}

extension GankType {
    private var urlEndcodingChar: String? { // 将url中的中文字符转换成可以识别的url字符
        return self.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var urlBaseString: String? {
        if let _urlEndcodingChar = self.urlEndcodingChar {
            return "http://gank.io/api/data/\(_urlEndcodingChar)/"
        }
        else {
            return nil
        }
    }
    
    var urlBaseStringForToday: String {
        return "http://gank.io/api/day/"
    }
    
    var pageCount: Int {
        get {
            return self.pageCount
        }
        set {
            pageCount = newValue
        }
    }
}

extension GankType {
    static var today: String {
        return "http://gank.io/api/day/2017/03/09"
    }
}

