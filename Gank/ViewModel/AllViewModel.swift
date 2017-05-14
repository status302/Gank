//
//  AllViewModel.swift
//  Gank
//
//  Created by vsccw on 2017/4/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct AllViewModel {
  let result: GankResult
  var publishAt: Variable<String>
  var desc: Variable<String>
  
  init(_ result: GankResult) {
    self.result = result
    publishAt = Variable<String>.init(result.publishedAt)
    desc = Variable<String>.init(result.desc)
  }
}
