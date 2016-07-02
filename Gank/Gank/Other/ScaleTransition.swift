//
//  ScaleTransition.swift
//  Gank
//
//  Created by 程庆春 on 16/6/15.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class ScaleTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting: Bool = true

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.3
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentViewControllerAnimation(transitionContext)
        }
    }

    func presentViewControllerAnimation(transitionContext: UIViewControllerContextTransitioning) {

        guard let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? WelfareViewController else {
            return
        }
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ShowWelfareViewController

        let containerView = transitionContext.containerView()

        var fromView = fromViewController.view
        var toView = toViewController!.view


        if transitionContext.respondsToSelector(#selector(UIViewControllerContextTransitioning.viewForKey(_:))) {
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        }

        fromView?.frame  = transitionContext.initialFrameForViewController(fromViewController)
        toView?.frame = transitionContext.finalFrameForViewController(toViewController!)

        containerView?.addSubview(toView)
        let currentCollectionView = fromViewController.collectionView
        guard let indexPath = fromViewController.indexPath else {
            return
        }
        guard let selectedCell = currentCollectionView.cellForItemAtIndexPath(indexPath) as? WelfareCollectionViewCell else {
            return
        }
        let animatedImageView = selectedCell.meiziImageView
        animatedImageView?.contentMode = .ScaleAspectFill
        animatedImageView?.clipsToBounds = true
        let originFrame = currentCollectionView.convertRect(selectedCell.frame, toView: toView)

        animatedImageView.frame = originFrame
        containerView?.addSubview(animatedImageView)

        let endFrame = coverImageFrameToFullScreenFrame(selectedCell.meiziImageView.image)

        toView.alpha = 0.0

        let duration = self.transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, animations:  {
            animatedImageView.frame = endFrame
        }) { (finished) in
            let wasCanceled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(wasCanceled)
            UIView.animateWithDuration(0.4, animations: { 
                toView.alpha = 1.0
                }, completion: { (finished) in
                    animatedImageView.removeFromSuperview()
            })
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ScaleTransition: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

func coverImageFrameToFullScreenFrame(image: UIImage?) -> CGRect {
    guard let image = image else  {
        return CGRectZero
    }

    let w:CGFloat = UIScreen.mainScreen().bounds.width
    let h:CGFloat = w * image.size.height / image.size.width
    let x:CGFloat = 0
    let y:CGFloat = (UIScreen.mainScreen().bounds.height - h) * 0.5;
    return CGRect(x: x, y: y, width: w, height: h)
}
