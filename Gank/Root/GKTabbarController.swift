//
//  GKTabbarController.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import FontAwesomeKit_Swift

class GKTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController()
        let homeNavigation = UINavigationController.init(rootViewController: homeVC)
        let homeItemImage = UIImage.init(awesomeType: .fa_home, size: 10, color: UIColor.black)
        homeNavigation.tabBarItem = UITabBarItem.init(title: "首页", image: homeItemImage, tag: 1)
        addChildViewController(homeNavigation)

        let categoryVC = UIViewController()
        categoryVC.view.backgroundColor = UIColor.red
        let categoryNavigaiton = UINavigationController.init(rootViewController: categoryVC)
        let categoryItemImage = UIImage.init(awesomeType: .fa_align_justify, size: 10, color: UIColor.black)
        categoryNavigaiton.tabBarItem = UITabBarItem.init(title: "类别", image: categoryItemImage, tag: 2)
        addChildViewController(categoryNavigaiton)

        let collectionVC = UIViewController()
        collectionVC.view.backgroundColor = UIColor.gray
        let collectionNavigation = UINavigationController.init(rootViewController: collectionVC)
        let collectionItemImage = UIImage.init(awesomeType: .fa_heart, size: 10, color: UIColor.black)
        collectionNavigation.tabBarItem = UITabBarItem.init(title: "收藏", image: collectionItemImage, tag: 3)
        addChildViewController(collectionNavigation)

        let settingVC = UIViewController()
        settingVC.view.backgroundColor = UIColor.blue.lighter()
        let settingNavigation = UINavigationController.init(rootViewController: settingVC)
        let settingItemImage = UIImage.init(awesomeType: .fa_cog, size: 10, color: UIColor.black)
        settingNavigation.tabBarItem = UITabBarItem.init(title: "设置", image: settingItemImage
            , tag: 4)
        addChildViewController(settingNavigation)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
