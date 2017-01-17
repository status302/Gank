//
//  ViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/1/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isStatusBarHidden = true
        
        
        let label = UILabel().then {
            $0.textColor = UIColor.white
            $0.text = "我是谁呀"
            $0.textAlignment = .center
        }
        
        view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(50)
            make.top.equalTo(view.snp.top).offset(100)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

