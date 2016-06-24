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

class QCWebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var backBarButton: UIBarButtonItem!

    @IBOutlet weak var forwardBarButton: UIBarButtonItem!

    @IBOutlet weak var openInSafiriBarButton: UIBarButtonItem!

    @IBOutlet weak var reloadBarButton: UIBarButtonItem!

    @IBOutlet weak var toolbar: UIToolbar! {
        didSet {
            for view in toolbar.subviews {
                if view.bounds.height < 2 {
                    if let view = view as? UIImageView {
                        view.removeFromSuperview()
                        break
                    }
                }
            }
        }
    }
    

    lazy var progressView: UIProgressView = {
        let progressView: UIProgressView = UIProgressView(progressViewStyle: .Default)

        progressView.trackTintColor = UIColor.lightGrayColor()
        progressView.progressTintColor = UIColor.blackColor()

        return progressView
    }()

    var isLoading: Bool = false {  // 表示 webView 是否在加载ing
        didSet {
            if isLoading { // 设置reloading 的图标为 X

                reloadBarButton.title = "Stop"

            } else { // 设置reloading 的图标为 G
                reloadBarButton.title = "Reload"

            }
        }
    }
    var webView: WKWebView!
    var url: String! {
        didSet {
            let URL = NSURL(string: url)
            let request = NSURLRequest(URL: URL!)
            webView.loadRequest(request)
        }
    }


    required init?(coder aDecoder: NSCoder) {

        webView = WKWebView(frame: CGRect.zero)
//        progressView = UIProgressView(progressViewStyle: .Default)

        super.init(coder: aDecoder)
    }

    override func loadView() {
        self.navigationController?.toolbar.removeFromSuperview()
        super.loadView()
//        self.hidesBottomBarWhenPushed = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

       webView.translatesAutoresizingMaskIntoConstraints = false


        webView.navigationDelegate = self
//        view.addSubview(webView)
        view.insertSubview(webView, atIndex: 0)

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

        backBarButton.enabled = false
        forwardBarButton.enabled = false

        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)

        ///设置navigationBar的返回按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), highlightedImage: UIImage(named: "back_highlighted"), target: self, action: #selector(back))

        /// 设置NavigationBar的分享按键
        let rightButton = UIButton(type: .System)
        rightButton.width = 22
        rightButton.height = 33
        rightButton.setImage(UIImage(named: "icon_share"), forState: .Normal)
        rightButton.contentMode = .ScaleAspectFill

        rightButton.tintColor = UIColor.blackColor()
        rightButton.addTarget(self, action: #selector(sharedButtonClicked), forControlEvents: .TouchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
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
    @objc private func sharedButtonClicked() {
        if let sharedUrl = NSURL(string: self.url) {
            let activityVC = UIActivityViewController(activityItems: [sharedUrl], applicationActivities: nil)

            self.presentViewController(activityVC, animated: true, completion: nil)
        }
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
        }
    }
    deinit {
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
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