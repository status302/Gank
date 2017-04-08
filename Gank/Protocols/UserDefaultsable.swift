//
//  UserDefaultsable.swift
//  Gank
//
//  Created by vsccw on 2017/4/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import Foundation

protocol UserDefaultsable {
}

extension UserDefaultsable {
  private var standard: UserDefaults {
    return UserDefaults.standard
  }
  
  private var readModeKey: String {
    return "Gank.SafariViewController.readmode"
  }
  
  var isReadMode: Bool {
    set {
      standard.set(newValue, forKey: readModeKey)
      standard.synchronize()
    }
    get {
      return standard.bool(forKey: readModeKey)
    }
  }
}

struct UserDefaultsType {
  static let manager = UserDefaultsType()
}

extension UserDefaultsType: UserDefaultsable {
  
}
