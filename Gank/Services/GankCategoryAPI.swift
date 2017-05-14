//
//  GankCategoryAPI.swift
//  Gank
//
//  Created by vsccw on 2017/4/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import Foundation
import Arrow
import RxSwift
import RxCocoa

protocol GankCategoryAPIAble {
  func getAllResult(_ page: Int) -> Observable<GankAllModel>
}

struct DefaultAllAPI: GankCategoryAPIAble {
  static let share = DefaultAllAPI()
  
  private init() { }
  
  func Json(_ url: URL) -> Observable<Data> {
    return URLSession.shared.rx
      .data(request: URLRequest.init(url: url))
  }
  
  func getAllResult(_ page: Int) -> Observable<GankAllModel> {
    let urlStr = "http://gank.io/api/data/all/20/\(page)"
    let url = URL.init(string: urlStr)!
    return Json(url)
      .observeOn(OperationQueueScheduler.init(operationQueue: OperationQueue()))
      .map({ data in
        guard let _json = JSON.init(data) else {
          fatalError("could not parsing.")
        }
        var allResult = GankAllModel()
        allResult.deserialize(_json)
        return allResult
      })
      .observeOn(MainScheduler.instance)
  }
}


