//
//  GKShowSettingAnimator.swift
//  Gank
//
//  Created by 程庆春 on 16/7/1.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
/*
class GKShowSettingAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    var isPresenting: Bool = true /// 用来标识是否为present：  true 为present   false 为dismiss
}
extension GKShowSettingAnimator {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 4.0
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        var fromView: UIView?
        var toView: UIView?

        if transitionContext.respondsToSelector(#selector(UIViewControllerContextTransitioning.viewForKey(_:))) {
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        } else {
            fromView = fromVC?.view
            toView = toVC?.view
        }

        let duration = self.transitionDuration(transitionContext)
        isPresenting = (toVC?.presentingViewController == fromVC)

        if isPresenting { /// 正在present的情况
            transitionContext.containerView()?.addSubview(toView!)
//            toView?.frame = (fromView?.frame)!
            toView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0) /// 设置起锚点的位置


            UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7111, initialSpringVelocity: 0.0, options: .CurveEaseIn, animations: {

                toView?.transform = CGAffineTransformIdentity
//                toView?.alpha = 1.0

                }, completion: { (finished) in
                    let wasCanceled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!wasCanceled)
            })

        } else { /// dismiss的情况
            /*
            fromView?.frame = fromViewFrame
            toView?.frame = toViewFrame
            fromView?.alpha = 1.0
            toView?.alpha = 0.0

            UIView.animateWithDuration(duration, animations: { 
                fromView?.frame = CGRect(x: 0, y: -fromViewFrame.size.height, width: fromViewFrame.size.width, height: fromViewFrame.size.height)
                toView?.alpha = 1.0
                fromView?.alpha = 0.0
                }, completion: { (finished) in
                    let wasCanceled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!wasCanceled)
            })
            */

        }
    }
}

extension GKShowSettingAnimator {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        isPresenting = true
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return nil
    }

}
 */
