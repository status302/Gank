//
//  GKSettingTransition.swift
//  Gank
//
//  Created by 程庆春 on 16/8/31.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit



class GKSettingTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var isPresenting = false
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.45
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentViewControllerTransition(transitionContext)
        } else {
            dismissViewControllerTransition(transitionContext)
        }

    }
    func presentViewControllerTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else {
            return
        }

        transitionContext.containerView()?.addSubview(toView)

        //        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        toView.height = 0.0
        toView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        toView.layer.position = CGPoint(x: 0, y: 0)

        let duration = transitionDuration(transitionContext)

        UIView.animateWithDuration(duration, animations: {
            //            toView.transform = CGAffineTransformIdentity
            toView.height = UIScreen.mainScreen().bounds.height
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }

    func dismissViewControllerTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else {
            return
        }
        fromView.height = UIScreen.mainScreen().bounds.height

        fromView.layer.position = CGPoint(x: 0.0, y: 0.0)
        fromView.layer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        let duration = 0.25 // transitionDuration(transitionContext)

        UIView.animateWithDuration(duration, animations: { 
            fromView.height = 0.00001
            }) { (finished) in
                transitionContext.completeTransition(true)
        }
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
