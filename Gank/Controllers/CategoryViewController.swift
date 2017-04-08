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
    
    let types: [GankType] = [GankType.all,
                             GankType.iOS,
                             GankType.frontEnd,
                             GankType.android,
                             GankType.resource,
                             GankType.welfare,
                             GankType.video,
                             GankType.other
                             ]
    for i in 0 ..< types.count {
      let childVC = CategoryDetailViewController.init(type: types[i])
      self.addChildViewController(childVC)
      childVC.view.backgroundColor = UIColor.gk_random
      scrollView.addSubview(childVC.view)
    }
    
    makeContraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func valueChange(view: CategoryTopScrollView) {
    let positionX = CGFloat(view.value) * self.view.frame.width
    scrollView?.setContentOffset(CGPoint.init(x: positionX, y: 0), animated: true)
  }
  
  func makeContraints() {
    scrollView?.snp.makeConstraints({ [weak self] in
      guard let strongSelf = self else { return }
      $0.edges.equalTo(strongSelf.view)
    })
    
    for (index ,childVC) in childViewControllers.enumerated() {
      let childView = childVC.view
      let firstView = childViewControllers.first?.view
      if index == 0 {
        childView?.snp.makeConstraints({ [weak self](make) in
          guard let scrollView = self?.scrollView,
            let strongSelf = self else { return }
          make.left.equalTo(scrollView.snp.left)
          make.top.equalTo(scrollView.snp.top)
          make.height.equalTo(strongSelf.view.snp.height)
          make.width.equalTo(strongSelf.view.snp.width)
        })
      }
      else if index == childViewControllers.count - 1 {
        let previousView = childViewControllers[index - 1].view
        childView?.snp.makeConstraints({ [weak self] (make) in
          guard let scrollView = self?.scrollView else { return }
          make.top.equalTo(firstView!.snp.top)
          make.left.equalTo(previousView!.snp.right)
          make.bottom.equalTo(firstView!.snp.bottom)
          make.width.equalTo(firstView!.snp.width)
          make.right.equalTo(scrollView.snp.right)
        })
      }
      else {
        let previousView = childViewControllers[index - 1].view
        childView?.snp.makeConstraints({ (make) in
          make.left.equalTo(previousView!.snp.right)
          make.top.equalTo(firstView!.snp.top)
          make.bottom.equalTo(firstView!.snp.bottom)
          make.width.equalTo(firstView!.snp.width)
        })
      }
    }
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
