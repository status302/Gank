//
//  SafariViewController.swift
//  Gank
//
//  Created by vsccw on 2017/4/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: SFSafariViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  convenience init(urlString url: String) {
    guard let urlToRequest = URL.init(string: url) else {
        fatalError("Could not load the url: \(url)")
    }
    self.init(url: urlToRequest, entersReaderIfAvailable: UserDefaultsType.manager.isReadMode)
  }
  
  private override init(url URL: URL, entersReaderIfAvailable: Bool) {
    super.init(url: URL, entersReaderIfAvailable: entersReaderIfAvailable)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.isStatusBarHidden = false
    UIView.animate(withDuration: 0.8) {  [weak self] in
      self?.setNeedsStatusBarAppearanceUpdate()
    }
  }
}
