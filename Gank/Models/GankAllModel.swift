//
//  GankAllModel.swift
//  Gank
//
//  Created by vsccw on 2017/4/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import Arrow

struct GankAllModel {
  var error: Bool = false
  var results: Array<GankResult>?
}

extension GankAllModel: ArrowParsable {
  mutating func deserialize(_ json: JSON) {
    error <-- json["error"]
    results <-- json["results"]
  }
}
