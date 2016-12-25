//
//  GKSettingNavController.swift
//  Gank
//
//  Created by 程庆春 on 16/8/30.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class GKSettingNavController: UINavigationController, GKSettingDismissDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let settingVC = self.topViewController as! GKSettingViewController
        settingVC.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func settingDismissNav(settingVC: GKSettingViewController, sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        }
    }

}
