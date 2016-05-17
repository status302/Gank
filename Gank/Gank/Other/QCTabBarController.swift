//
//  QCTabBarController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/17.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class QCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //添加自定义的tabBar
        let tabBarView = self.tabBarView
        self.tabBar.addSubview(tabBarView)
    }


    // 懒加载tabBarView
    private lazy var tabBarView: QCTabBar = {
        let tabbarView = QCTabBar.tabbar()
        tabbarView.frame = self.tabBar.bounds
        return tabbarView
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.tabBar.frame.size.height = 36.0
        self.tabBar.frame.origin.y = UIScreen.mainScreen().bounds.size.height - self.tabBar.frame.size.height
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // 移除自带的tabBar
        for button in self.tabBar.subviews {
            if button.isKindOfClass(UIControl) {
                button.removeFromSuperview()
            }
        }
    }

}
