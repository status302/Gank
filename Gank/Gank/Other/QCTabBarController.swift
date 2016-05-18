//
//  QCTabBarController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/17.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class QCTabBarController: UITabBarController, QCTabBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarView.delegate = self

        //添加自定义的tabBar
        let tabBarView = self.tabBarView
        self.tabBar.addSubview(tabBarView)

        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.redColor()
        self.addChildViewController(self.setupChildViewControllers(vc1, titleText: "干货"))
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.orangeColor()
        self.addChildViewController(self.setupChildViewControllers(vc2, titleText: "分类"))

        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.blueColor()
        self.addChildViewController(self.setupChildViewControllers(vc3, titleText: "福利"))



    }



    func setupChildViewControllers(vc: UIViewController, titleText: String) -> UIViewController {
        let navigation = UINavigationController()
        vc.navigationItem.title = titleText
        navigation.addChildViewController(vc)
        return navigation
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
    // MARK: - QCTabBarDelegate
    func tabBarDidSelected(fromButtonWithTag from: Int, to: Int, title: String) {
        self.selectedIndex = to % 100
    }
}
