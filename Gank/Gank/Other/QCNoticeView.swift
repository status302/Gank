//
//  QCNoticeView.swift
//  Gank
//
//  Created by 程庆春 on 16/7/6.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

protocol QCNoticeViewDelegate {
    func noticeViewDidClickTryToRefreshButton(noticeView: QCNoticeView, sender: UIButton)
}

class QCNoticeView: UIView {
    typealias CompletedHandler = ((finished: Bool) -> Void)?
    let animationDuration = 3.00
    let kIconAnimationKeyPath = "transform.rotation"
    let kFourLabelAnimationKeyPath = "textColor"

    var delegate: QCNoticeViewDelegate?

    @IBOutlet weak var iconImageView: UIImageView!

    @IBAction func tryFreshButtonClicked(sender: AnyObject) {
        delegate?.noticeViewDidClickTryToRefreshButton(self, sender: sender as! UIButton)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.alpha = 0.0
        self.backgroundColor = UIColor.clearColor()
    }

    func startAnimation() {
        // animate the iconImageView 
        let iconAnimation = CABasicAnimation(keyPath: kIconAnimationKeyPath)
        iconAnimation.fromValue = 0
        iconAnimation.toValue = M_PI * 2
        iconAnimation.repeatCount = 10
        iconAnimation.duration = animationDuration
        iconAnimation.removedOnCompletion = true

        iconImageView.layer.addAnimation(iconAnimation, forKey: kIconAnimationKeyPath)

//        let oneFourLabelAnimation = CABasicAnimation(keyPath: "textColor")
//        oneFourLabelAnimation.duration = labelAnimationDuration
//        oneFourLabelAnimation.fromValue = UIColor.randomColor()
//        oneFourLabelAnimation.toValue = UIColor.randomColor()
//        oneFourLabelAnimation.repeatCount = 4
//        oneFourLabelAnimation.removedOnCompletion = true
//
//        fourLabel.layer.addAnimation(oneFourLabelAnimation, forKey: "textColor")
////        fourTwoLabel.layer.addAnimation(oneFourLabelAnimation, forKey: kFourLabelAnimationKeyPath)
    }
    func setNoticeViewHidden(completedhandler: CompletedHandler) {
        completedhandler!(finished: true)
        UIView.animateWithDuration(0.2) {
            self.alpha = 0.0
        }
    }
    func setNoticeViewShow(comletedHandler: CompletedHandler) {
        UIView.animateWithDuration(0.2) { 
            self.alpha = 1.0
        }
        startAnimation()
        comletedHandler!(finished: true)
    }
    class func loadNoticeView() -> QCNoticeView {
        return NSBundle.mainBundle().loadNibNamed("QCNoticeView", owner: nil, options: nil).first as! QCNoticeView
    }
}
