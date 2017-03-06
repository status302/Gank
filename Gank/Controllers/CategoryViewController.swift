//
//  CategoryViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/1.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    weak var bgView: CategoryTopScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = CategoryTopScrollView()
            .then({ [weak self] in
                $0.backgroundColor = UIColor.clear
                $0.frame = CGRect(x: 12, y: 0, width: UIScreen.mainWidth - 24, height: 44)
                self?.bgView = $0
                $0.addTarget(self, action: #selector(self?.valueChange(view:)), for: .touchUpInside)
            })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func valueChange(view: CategoryTopScrollView) {
        
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
