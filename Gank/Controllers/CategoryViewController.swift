//
//  CategoryViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/1.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    fileprivate weak var bgView: CategoryTopScrollView?
    fileprivate weak var scrollView: UIScrollView?
    var childView1: UIView?
    var childView2: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

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
            $0.bounces = true
            $0.contentInset = UIEdgeInsets.zero
            $0.delegate = self
            self.scrollView = $0
            $0.backgroundColor = UIColor.lightGray
        })
        view.addSubview(scrollView)

        let childVC = CategoryDetailViewController.init(type: .all)
        self.addChildViewController(childVC)
        view.addSubview(childVC.view)
        childView1 = childVC.view

        let childVC2 = CategoryDetailViewController.init(type: .iOS)
        self.addChildViewController(childVC2)
        view.addSubview(childVC2.view)
        childView2 = childVC2.view

        makeContraints()
    }
    
    func valueChange(view: CategoryTopScrollView) {
        print(view.value)
    }

    func makeContraints() {
        scrollView?.snp.makeConstraints({
            $0.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 49.0, right: 0))
        })

        childView1?.snp.makeConstraints({
          guard let scrollView = scrollView else { return }
            $0.left.equalTo(scrollView.snp.left)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CategoryViewController: UIScrollViewDelegate {
    
}
