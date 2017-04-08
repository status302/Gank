//
//  CategoryViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/1.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CategoryViewController: UIViewController {
  
  fileprivate weak var bgView: CategoryTopScrollView?
  fileprivate weak var scrollView: UIScrollView?
  var childView1: UIView?
  var childView2: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.automaticallyAdjustsScrollViewInsets = false
    
    self.navigationItem.titleView = CategoryTopScrollView()
      .then({ [weak self] in
        $0.backgroundColor = UIColor.clear
        $0.frame = CGRect(x: 12, y: 0, width: UIScreen.mainWidth - 24, height: 44)
        self?.bgView = $0
        $0.addTarget(self, action: #selector(self?.valueChange(view:)), for: .valueChanged)
      })
    
    
    let scrollView = UIScrollView.init().then({
      $0.showsVerticalScrollIndicator = false
      $0.showsHorizontalScrollIndicator = false
      $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
      $0.isPagingEnabled = true
      $0.bounces = true
      $0.delegate = self
      $0.backgroundColor = UIColor.lightGray
    })
    self.scrollView = scrollView
    view.addSubview(scrollView)
    
    let childVC = CategoryDetailViewController.init(type: .all)
    self.addChildViewController(childVC)
    childVC.view.backgroundColor = UIColor.blue
    scrollView.addSubview(childVC.view)
    childView1 = childVC.view
    
    let childVC2 = CategoryDetailViewController.init(type: .iOS)
    self.addChildViewController(childVC2)
    childVC2.view.backgroundColor = UIColor.orange
    scrollView.addSubview(childVC2.view)
    childView2 = childVC2.view
    
    makeContraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func valueChange(view: CategoryTopScrollView) {
    print(view.value)
  }
  
  func makeContraints() {
    scrollView?.snp.makeConstraints({ [weak self] in
      guard let strongSelf = self else { return }
      $0.edges.equalTo(strongSelf.view)
    })
    
    childView1?.snp.makeConstraints({ [weak self] in
      guard let scrollView = self?.scrollView, let strongSelf = self else { return }
      $0.left.equalTo(scrollView.snp.left)
      $0.top.equalTo(scrollView.snp.top)
      $0.height.equalTo(strongSelf.view.snp.height)
      $0.width.equalTo(strongSelf.view.snp.width)
    })
    
    childView2?.snp.makeConstraints({ [weak self] in
      guard let scrollView = self?.scrollView,
        let childView1 = self?.childView1 else { return }
        $0.top.equalTo(childView1.snp.top)
        $0.bottom.equalTo(childView1.snp.bottom)
        $0.left.equalTo(childView1.snp.right)
        $0.width.equalTo(childView1.snp.width)
        $0.right.equalTo(scrollView.snp.right)
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

extension CategoryViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = scrollView.contentOffset.x / self.view.frame.width
    bgView?.setSelected(Int(index))
  }
}
