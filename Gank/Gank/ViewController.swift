//
//  ViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/17.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//
//  启动动画的设置

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5))
        dispatch_after(time, dispatch_get_main_queue()) {
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
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.iconImageView.layer.removeAllAnimations()
    }


}

extension ViewController {
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        UIView.animateWithDuration(0.5, animations: { 
            self.iconImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        }) {
            (finished) in
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .CurveLinear, animations: {

                self.iconImageView.transform = CGAffineTransformTranslate(self.iconImageView.transform, 100, 100)
                }, completion: {
                    (finished) in

            })
        }
    }
}

