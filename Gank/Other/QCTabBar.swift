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

    @IBOutlet weak var everyDayGankButton: UIButton!
    @IBOutlet weak var gankSortButton: UIButton!
    @IBOutlet weak var meiziWelfareButton: UIButton!

    var selectedButton: UIButton!


    var delegate: QCTabBarDelegate?

    class func tabbar() -> QCTabBar{
        return NSBundle.mainBundle().loadNibNamed("QCTabBar", owner: nil, options: nil).first as! QCTabBar
    }

    /**
     *  when first load from nib, the first tab is everyDayGankButton
     */
    override func awakeFromNib() {
        super.awakeFromNib()

        selectedButton = everyDayGankButton
        selectedButton.enabled = false
    }


    /**
     *  tags: everyDayGankButton = 100, gankSortButton = 101,  meiziWelfareButton = 102
     */

    @IBAction func tabBarButtonDidClicked(sender: UIButton) {
        guard selectedButton != sender else {
            return
        }

        selectedButton.enabled = true
        delegate?.tabBarDidSelected(fromButtonWithTag: selectedButton.tag, to: sender.tag, title: (sender.titleLabel?.text)!)
        selectedButton = sender
        selectedButton.enabled = false

    }


}
