//
//  QCNavigationController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class QCNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        hidesBottomBarWhenPushed = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
