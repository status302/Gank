//
//  ScaleTransition.swift
//  Gank
//
//  Created by 程庆春 on 16/6/15.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class ScaleTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.3
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        let containerView = transitionContext.containerView()

        var fromView = fromViewController!.view
        var toView = toViewController!.view


        if transitionContext.respondsToSelector(#selector(UIViewControllerContextTransitioning.viewForKey(_:))) {
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        }

        fromView?.frame  = transitionContext.initialFrameForViewController(fromViewController!)
        toView?.frame = transitionContext.finalFrameForViewController(toViewController!)

        fromView?.alpha = 1.0
        toView?.alpha  = 0.0

        containerView?.addSubview(toView)

        let duration = self.transitionDuration(transitionContext)

        UIView.animateWithDuration(duration, animations: { 
            fromView?.alpha = 0.0
            toView?.alpha = 1.0
        }) { (finished: Bool) in
            let wasCanceled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(wasCanceled)
        }
    }
}
