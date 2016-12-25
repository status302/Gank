//
//  GKSettingHeaderView.swift
//  Gank
//
//  Created by 程庆春 on 16/8/30.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class GKSettingHeaderView: UIView {

    @IBOutlet weak var versionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        versionLabel.text = "version: \(GKApp.appVersion!) (\(GKApp.appBuildVersion!))"
    }

    class func headerView() -> GKSettingHeaderView {
        return NSBundle.mainBundle().loadNibNamed(GKSettingHeaderView.nibName, owner: nil, options: nil).first as! GKSettingHeaderView
    }

}
