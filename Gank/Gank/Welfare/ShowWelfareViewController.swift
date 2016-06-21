//
//  ShowWelfareViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/2.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import PKHUD

class ShowWelfareViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var result: Result?
    weak var imageView: UIImageView?

    var actionView: QCActionView?

    override func viewDidLoad() {
        super.viewDidLoad()

        var image: UIImage?

        if let result = result  {
            let imageData = NSData(contentsOfURL: NSURL(string: result.url)!)
            image = UIImage(data: imageData!)
        }
        let width = image?.size.width
        let height = image?.size.height

        let imageViewHeight = Common.Screen_width / width! * height!
        let imageView = UIImageView(frame: CGRectMake(0, 0, Common.Screen_width, imageViewHeight))
        imageView.contentMode = .ScaleAspectFit
        if imageViewHeight < Common.Screen_height {
            imageView.center.y = UIScreen.mainScreen().bounds.height * 0.5
            self.scrollView.contentSize = CGSizeMake(0, Common.Screen_height + 5)
        } else {
            self.scrollView.contentSize = CGSizeMake(0, imageViewHeight)

        }
        imageView.image = image!
        imageView.userInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didClickDismissButton(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureRecognizer(_:)))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGestureToSavePhoto(_:)))
        longGesture.minimumPressDuration = 0.8

        
        imageView.addGestureRecognizer(tapGesture)
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(longGesture)



        self.scrollView.addSubview(imageView)

        self.imageView = imageView


        // scrollView 
        self.scrollView.minimumZoomScale = 0.5
        self.scrollView.maximumZoomScale =  1.5
        self.scrollView.delegate = self

        // ActionView
        actionView = QCActionView()
        actionView?.items = ["分享", "保存图片"]

    }

    /**
     *  实现放大缩小
     */
    @objc private func pinchGestureRecognizer(gesture: UIPinchGestureRecognizer) {

    }
    /**
     *  实现长按保存图片
     */
    @objc private func longGestureToSavePhoto(recognizer: UILongPressGestureRecognizer) {


        if recognizer.state == .Began {

            actionView?.showActionView({ (index) in
                if index == 0 {
                    HUD.flash(.Label("分享正在做呢！"), delay: 0.5)
                } else {
                    // 保存图片
                    UIImageWriteToSavedPhotosAlbum(self.imageView!.image!, self, #selector(self.image), nil)
                }
            })
        }

//        UIImageWriteToSavedPhotosAlbum(self.imageView!.image!, self, #selector(image), nil)

    }

    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        HUD.flash(.LabeledSuccess(title: "", subtitle: "保存图片成功"), delay: 0.4)

    }


    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)


    }
    /**
     *  单击或者点击dismiss按钮取消图片
     */
    @IBAction func didClickDismissButton(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
//        self.dismissViewControllerAnimated(true) {
//            print("已经退出----")
//        }
    }

   /* public func panGestureRecognized(sender: UIPanGestureRecognizer) {
        backgroundView.hidden = true
        let scrollView = pageDisplayedAtIndex(currentPageIndex)

        let viewHeight = scrollView.frame.size.height
        let viewHalfHeight = viewHeight/2

        var translatedPoint = sender.translationInView(self.view)

        // gesture began
        if sender.state == .Began {
            firstX = scrollView.center.x
            firstY = scrollView.center.y

            senderViewForAnimation?.hidden = (currentPageIndex == initialPageIndex)

            isDraggingPhoto = true
            setNeedsStatusBarAppearanceUpdate()
        }

        translatedPoint = CGPoint(x: firstX, y: firstY + translatedPoint.y)
        scrollView.center = translatedPoint

        let minOffset = viewHalfHeight / 4
        let offset = 1 - (scrollView.center.y > viewHalfHeight ? scrollView.center.y - viewHalfHeight : -(scrollView.center.y - viewHalfHeight)) / viewHalfHeight
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(max(0.7, offset))

        // gesture end
        if sender.state == .Ended {
            if scrollView.center.y > viewHalfHeight + minOffset || scrollView.center.y < viewHalfHeight - minOffset {
                backgroundView.backgroundColor = self.view.backgroundColor
                determineAndClose()
                return
            } else {
                // Continue Showing View
                isDraggingPhoto = false
                setNeedsStatusBarAppearanceUpdate()

                let velocityY: CGFloat = CGFloat(self.animationDuration) * sender.velocityInView(self.view).y
                let finalX: CGFloat = firstX
                let finalY: CGFloat = viewHalfHeight

                let animationDuration = Double(abs(velocityY) * 0.0002 + 0.2)

                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(animationDuration)
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
                view.backgroundColor = UIColor.blackColor()
                scrollView.center = CGPoint(x: finalX, y: finalY)
                UIView.commitAnimations()
            }
        }
    }*/
    @IBAction func dismissVC(segue: UIStoryboardSegue) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShowWelfareViewController: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
