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

        let everydayGankVC = QCEveryDayGnakViewController()
        everydayGankVC.view.backgroundColor = UIColor.redColor()
        self.addChildViewController(self.setupChildViewControllers(everydayGankVC, titleText: "每日一Gank"))

        /// 添加sortVC
        let sb = UIStoryboard(name: "Sort", bundle: nil)
        guard let sortVC = sb.instantiateInitialViewController() else {
            return
        }
        
        self.addChildViewController(sortVC)

        // 添加WelfareVC
        let welfareVC = WelfareViewController()
        welfareVC.view.backgroundColor = UIColor.whiteColor()
        self.addChildViewController(setupChildViewControllers(welfareVC, titleText: "福利"))

    }

    func setupChildViewControllers(vc: UIViewController, titleText: String) -> UIViewController {
        let navigation = UINavigationController()
        let titlelabel = UILabel()
        titlelabel.text = titleText
        titlelabel.font = UIFont(name: "DFPHaiBaoW12-GB", size: 18)
        titlelabel.sizeToFit()
        vc.navigationItem.titleView = titlelabel
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
