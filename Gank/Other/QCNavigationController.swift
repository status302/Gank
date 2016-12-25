//
//  QCNavigationController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class QCNavigationController: UINavigationController,UINavigationControllerDelegate,  UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
        delegate = self

    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        if animated {
//            interactivePopGestureRecognizer?.enabled = false
        }
        return super.popViewControllerAnimated(animated)
    }
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if animated {
//            interactivePopGestureRecognizer?.enabled = false
        }
        return super.popToViewController(viewController, animated: animated)
    }
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        if animated {
//            interactivePopGestureRecognizer?.enabled = false
        }
        return super.popToRootViewControllerAnimated(animated)
    }

    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.enabled = true
    }

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.viewControllers[0] == self.visibleViewController {
                return false
            }
        }
        return true
    }

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if animated {
//            interactivePopGestureRecognizer?.enabled = false
        }
        super.pushViewController(viewController, animated: true)
    }
}
