//
//  SlideTransitionAnimator.swift
//  Gank
//
//  Created by 程庆春 on 16/6/25.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class SlideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.35
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        let containerView = transitionContext.containerView()

        let fromView: UIView?
        let toView: UIView?

        
        if transitionContext.respondsToSelector(#selector(UIViewControllerContextTransitioning.viewForKey(_:))) {
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        } else {
            fromView = fromViewController?.view
            toView = toViewController?.view
        }


        var fromFrame = transitionContext.initialFrameForViewController(fromViewController!)
        var toFrame = transitionContext.initialFrameForViewController(toViewController!)

        fromFrame = (fromView?.frame)!
//        toFrame = CGRectOffset(toFrame, toFrame.width, 0)
        toFrame = CGRect(x: toFrame.width, y: toFrame.origin.y, width: toFrame.width, height: toFrame.height)

        containerView?.addSubview(toView!)

        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, animations: { 
//            fromView?.frame = CGRectOffset(fromFrame, fromFrame.width, 0)
            fromView?.frame = CGRect(x: -fromFrame.width, y: fromFrame.origin.y, width: fromFrame.width, height: fromFrame.height)

            toView?.frame = toFrame
            }) { (finished) in
                let wasCanceled = transitionContext.transitionWasCancelled()

                transitionContext.completeTransition(wasCanceled)
        }

    }

}
