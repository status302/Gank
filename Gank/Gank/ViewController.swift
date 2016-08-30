//
//  ViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/17.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//
//  启动动画的设置

import UIKit

class ViewController: UIViewController, QCTextAnimatorDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
//    @IBOutlet weak var welcomeLabel: LTMorphingLabel!

    @IBOutlet weak var gankView: UIView!

    var textAnimator: QCTextAnimator?
    var choseFontName: String = "Lobster1.4"
    var isTextAnimating = false // 用来记录textAnimator的状态

    var iconImageViewY: CGFloat? // 记录iconImageView的初始y值

    var distanceTransform: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        welcomeLabel.font = UIFont.font_heart(size: 56)
//        welcomeLabel.textColor = UIColor.yellowColor()
//        welcomeLabel.alpha = 1.0
//        welcomeLabel.text = ""
//        let effect = LTMorphingEffect.Sparkle
//        welcomeLabel.morphingEffect = effect
//        welcomeLabel.text = "Welcome"

        iconImageViewY = iconImageView.y
        distanceTransform = (gankView.y - self.iconImageView.y - iconImageView.height) * 0.5

        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0))
        dispatch_after(time, dispatch_get_main_queue()) {

            self.startTextAnimator()

            let rotationAnimation = CABasicAnimation()
            rotationAnimation.keyPath = "transform.rotation"
            rotationAnimation.fromValue = 0
            rotationAnimation.toValue = M_PI * 2
            rotationAnimation.duration = 1
            rotationAnimation.repeatCount = 2

            rotationAnimation.removedOnCompletion = true
            rotationAnimation.delegate = self
            
            self.iconImageView.layer.addAnimation(rotationAnimation, forKey: "transform.ratotion")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        initTextAnimator()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.iconImageView.layer.removeAllAnimations()
        textAnimator = nil
    }
    func initTextAnimator() {
        textAnimator = QCTextAnimator(referenceView: gankView)
        textAnimator?.delegate = self
        updateTextAnimator()
    }
    func updateTextAnimator() {
        textAnimator?.textToAnimate = "GANK"
    }
    func startTextAnimator() {

        textAnimator?.startAnimation()
    }
    func stopTextAnimator() {
        textAnimator?.stopAnimation()
    }

    func labelChangeText(label:UILabel, text: String) {
        label.text = text
    }
}

extension ViewController {

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {

        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: .CurveEaseIn, animations: {
            self.iconImageView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            }) { (finished) in

        }
    }
}

extension ViewController {
    func animateDidStart(textAnimator: QCTextAnimator, animatorDidStart animator: CAAnimation) {
        isTextAnimating = true
    }
    func animateDidStop(textAnimator: QCTextAnimator, animatorDidStop animator: CAAnimation) {
        isTextAnimating = false
    }

}
