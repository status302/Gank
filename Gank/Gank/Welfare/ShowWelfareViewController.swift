//
//  ShowWelfareViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/2.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher
import MonkeyKing

class ShowWelfareViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var result: Result?
    weak var imageView: UIImageView?
    var image: UIImage!
    var imageUrl: String! {
        didSet {
            let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
            image = UIImage(data: imageData!)
        }
    }

    var actionView: QCActionView?

    override func viewDidLoad() {
        super.viewDidLoad()


        if let result = result  {
            imageUrl = result.url
        }
        let width = image.size.width
        let height = image.size.height

        let imageViewHeight = Common.Screen_width / width * height
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


        // ActionView
        actionView = QCActionView()
        actionView?.items = ["分享", "保存图片"]

    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.imageView?.removeFromSuperview()
    }


    // MARK: - Actions
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
            moreButtonClicked(self)
        }

//        UIImageWriteToSavedPhotosAlbum(self.imageView!.image!, self, #selector(image), nil)

    }

    func savedImage(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        HUD.flash(.LabeledSuccess(title: "", subtitle: "保存图片成功"), delay: 0.4)

    }

    @IBAction func moreButtonClicked(sender: AnyObject) {

        actionView?.showActionView({ (index) in
            if index == 0 {
                guard let image = self.imageView?.image else {
                    return
                }
                let info = MonkeyKing.Info(title: NSLocalizedString("来自Gank, 一款追求极致的干货集中营客户端", comment: ""), description: NSLocalizedString("", comment: ""), thumbnail: image, media: MonkeyKing.Media.Image(image))
                let wechatSession = MonkeyKing.Message.WeChat(.Session(info: info))
                let sessionActivity = WeChatActivity(type: .Session, message: wechatSession, completionHandler: { (result) in
                    print("success shared to wechat")
                })

                let wechatTimeline = MonkeyKing.Message.WeChat(.Timeline(info: info))
                let timelineActivity = WeChatActivity(type: .Timeline, message: wechatTimeline, completionHandler: { (result) in
                    print("success shared to wechat")
                })

                let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: [sessionActivity, timelineActivity])
                activityVC.excludedActivityTypes = [UIActivityTypeMail,UIActivityTypePrint]

                self.presentViewController(activityVC, animated: true, completion: nil)
            } else {
                // 保存图片
                UIImageWriteToSavedPhotosAlbum(self.imageView!.image!, self, #selector(self.savedImage), nil)
            }
        })


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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

