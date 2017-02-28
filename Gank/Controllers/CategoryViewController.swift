//
//  CategoryViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/1.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    weak var bgView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

//        UIApplication.shared.isStatusBarHidden = false

        let bgView = UIView().then({ [weak self] in
            $0.backgroundColor = UIColor.gray
            self?.bgView = $0
        })
        self.navigationItem.titleView = bgView
        bgView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
    }


    func makeContraints() {
        guard let superView = bgView?.superview else {
            return
        }
        bgView?.snp.makeConstraints({
            $0.left.equalTo(superView.snp.left).offset(10)
            $0.top.equalTo(superView.snp.top)
            $0.bottom.equalTo(superView.snp.bottom)
            $0.right.equalTo(superView.snp.right).offset(-10)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
