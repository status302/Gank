//
//  QCWebViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/23.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import MonkeyKing

class QCWebViewController: UIViewController, WKNavigationDelegate {

    // MARK: Outlets and properties
    @IBOutlet weak var backBarButton: UIBarButtonItem!

    @IBOutlet weak var forwardBarButton: UIBarButtonItem!

    @IBOutlet weak var openInSafiriBarButton: UIBarButtonItem!

    @IBOutlet weak var reloadBarButton: UIBarButtonItem!

    @IBOutlet weak var toolbar: UIToolbar!
    
    var isLoading: Bool = false {  // 表示 webView 是否在加载ing
        didSet {
            if isLoading { // 设置reloading 的图标为 X

                UIView.animateWithDuration(0.0889, animations: {
                    self.reloadBarButton.image = UIImage(named: "cancel")
                })

            } else { // 设置reloading 的图标为 G
                UIView.animateWithDuration(0.0889, animations: {
                    self.reloadBarButton.image = UIImage(named: "networking_refresh")
                })

            }
        }
    }
    var url: String! {
        didSet {
            let URL = NSURL(string: url)
            let request = NSURLRequest(URL: URL!)
            webView.loadRequest(request)
        }
    }
    // MARK: Lazy
    lazy var progressView: UIProgressView = {
        let progressView: UIProgressView = UIProgressView(progressViewStyle: .Default)

        progressView.trackTintColor = UIColor.lightGrayColor()
        progressView.progressTintColor = UIColor.blackColor()

        return progressView
    }()

    lazy var webView: WKWebView = {
        let conf = WKWebViewConfiguration()  // 配置webView
        conf.allowsAirPlayForMediaPlayback = true
        conf.allowsPictureInPictureMediaPlayback = false
        conf.allowsInlineMediaPlayback = false
        conf.requiresUserActionForMediaPlayback = true
        conf.suppressesIncrementalRendering = false

        let pref = WKPreferences()
        pref.minimumFontSize = 12
        conf.preferences = pref

        let webView = WKWebView(frame: CGRect.zero, configuration: conf)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true

        webView.navigationDelegate = self

        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.scrollView.delegate = self

        return webView
    }()



    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        view.insertSubview(webView, atIndex: 0)

        navigationController?.hidesBarsOnSwipe = true
//        navigationController?.hidesBarsOnTap = true

        webView.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).offset(-44)
        }

        view.insertSubview(progressView, aboveSubview: webView)

        progressView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top).offset(64)
        }

        // MARK: Add Observer
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)

        backBarButton.enabled = false
        forwardBarButton.enabled = false

        ///设置navigationBar的返回按钮
//        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), highlightedImage: UIImage(named: "back_highlighted"), target: self, action: #selector(back))

        /// 设置NavigationBar的分享按键
        let rightButton = UIButton(type: .System)
        rightButton.width = 22
        rightButton.height = 33
        rightButton.setImage(UIImage(named: "share"), forState: .Normal)
        rightButton.setImage(UIImage(named: "share_highlighted"), forState: .Highlighted)
        rightButton.contentMode = .ScaleAspectFill

        rightButton.tintColor = UIColor.blackColor()
        rightButton.addTarget(self, action: #selector(sharedButtonClicked), forControlEvents: .TouchUpInside)

        navigationItem.rightBarButtonItem  = UIBarButtonItem(customView: rightButton)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
//        navigationController?.hidesBarsOnTap = false
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.webView.stopLoading()
        self.webView.removeFromSuperview()
    }

    // MARK: - Actions

    @IBAction func backBarButtonCicked(sender: AnyObject) {
        webView.goBack()
    }
    @IBAction func forwardBarButtonClicked(sender: AnyObject) {
        webView.goForward()
    }
    @IBAction func openInSafiriBarButtonClicked(sender: AnyObject) {
        if let URL = NSURL(string: self.url) {
            UIApplication.sharedApplication().openURL(URL)
        }
    }
    @IBAction func reloadBarButtonClicked(sender: AnyObject) {

        if isLoading {
            webView.stopLoading()
            isLoading = false
        } else {
            webView.reload()
            isLoading = true
        }
    }
    // MARK: - Private functions 
    /**
       分享
     */
    @objc private func sharedButtonClicked() {
        guard let sharedUrl = NSURL(string: self.url) else {
            return
        }

        let info = MonkeyKing.Info(title: NSLocalizedString("来自Gank, 一款追求极致的干货集中营客户端", comment: ""), description: NSLocalizedString("\(webView.title!)", comment: ""), thumbnail: UIImage(named: "icon"), media: MonkeyKing.Media.URL(sharedUrl))

        let sessionMessage = MonkeyKing.Message.WeChat(.Session(info: info))

        let wechatSession = WeChatActivity(type: .Session, message: sessionMessage) { (result) in
            print("success in share to wechat session")
        }

        let timeLineMessage = MonkeyKing.Message.WeChat(.Timeline(info: info))
        let wechatTimeLine = WeChatActivity(type: .Timeline, message: timeLineMessage) { (result) in
            print("success in share to wechat timeline")
        }

        let activityVC = UIActivityViewController(activityItems: [sharedUrl], applicationActivities: [wechatSession, wechatTimeLine])
        activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypeMail]
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    @objc func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            backBarButton.enabled = webView.canGoBack
            forwardBarButton.enabled = webView.canGoForward

        } else if keyPath == "estimatedProgress" {
            progressView.hidden = (webView.estimatedProgress == 1.0)
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        } else if keyPath == "title"{
            title = webView.title
        }
    }
    deinit {
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
        self.webView.scrollView.delegate = nil
    }
}
extension QCWebViewController {
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

        isLoading = true

    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        isLoading = false
        progressView.setProgress(0, animated: true)
    }
}

extension QCWebViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        UIView.animateWithDuration(0.5) {
//            self.toolbar.transform = CGAffineTransformIdentity
        }
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        UIView.animateWithDuration(0.5) {
//            self.toolbar.transform = CGAffineTransformMakeTranslation(0, self.toolbar.height)
        }
    }
}