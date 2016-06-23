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

    var progressView: UIProgressView!

    var isLoading: Bool = false {  // 表示 webView 是否在加载ing
        didSet {
            if isLoading { // 设置reloading 的图标为 X
                reloadBarButton.image = UIImage(named: "stop")
                view.layoutIfNeeded()
            } else { // 设置reloading 的图标为 G
                reloadBarButton.image = UIImage(named: "reload")
                print("web view is not loading!")
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
        progressView = UIProgressView(progressViewStyle: .Default)

        super.init(coder: aDecoder)
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

    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.webView.stopLoading()
    }

    // MARK: - Actions

    @IBAction func backBarButtonCicked(sender: AnyObject) {
        webView.goBack()
    }
    @IBAction func forwardBarButtonClicked(sender: AnyObject) {
        webView.goForward()
    }
    @IBAction func openInSafiriBarButtonClicked(sender: AnyObject) {
    }
    @IBAction func reloadBarButtonClicked(sender: AnyObject) {
    }

    // MARK: - KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            print("loading")
            backBarButton.enabled = webView.canGoBack
            forwardBarButton.enabled = webView.canGoForward

        } else if keyPath == "estimatedProgress" {
            progressView.hidden = (webView.estimatedProgress == 1.0)
            print("\(webView.estimatedProgress)")
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
        print("hahhaha\(webView.estimatedProgress)")
        progressView.setProgress(0, animated: true)
    }
}