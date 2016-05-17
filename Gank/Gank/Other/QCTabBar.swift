//
//  QCTabBar.swift
//  Gank
//
//  Created by 程庆春 on 16/5/17.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

protocol QCTabBarDelegate {
    func tabBarDidSelected(fromButtonWithTag from:Int, to: Int, title: String)
}


class QCTabBar: UIView {

    @IBOutlet weak var EveryDayGankButton: UIButton!
    @IBOutlet weak var gankSortButton: UIButton!
    @IBOutlet weak var meiziWelfareButton: UIButton!

    var selectedButton: UIButton!


    var delegate: QCTabBarDelegate?

    class func tabbar() -> QCTabBar{
        return NSBundle.mainBundle().loadNibNamed("QCTabBar", owner: nil, options: nil).first as! QCTabBar
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectedButton = EveryDayGankButton
        selectedButton.enabled = false
    }



    @IBAction func tabBarButtonDidClicked(sender: UIButton) {
        print("button's tag is : \(sender.tag)")

        guard selectedButton != sender else {
            return
        }

        selectedButton.enabled = true
        selectedButton = sender
        selectedButton.enabled = false

    }


}
