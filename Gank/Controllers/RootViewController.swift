//
//  ViewController.swift
//  Gank
//
//  Created by 程庆春 on 2017/1/8.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var tableView: UITableView?
    var bgScrollView: UIScrollView?
    var tabbarView: UIView?
    var topScrollView: TopScrollView?
    var statusBarView: UIView?
    var resultJson: GankJson? {
        didSet {
            topScrollView?.imageJson = resultJson
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.clear
    
        self.navigationController?.do({
            $0.navigationBar.shadowImage = UIImage()
            $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
        })
        
        let scrollView = TopScrollView().then({_ in
//            $0.backgroundColor = UIColor.gk_random
        })
        scrollView.addedTo(view: view)
        self.topScrollView = scrollView
        scrollView.makeConstraints()
        
        let statusBar = UIView().then({
            $0.backgroundColor = UIColor(white: 1.0, alpha: 0.88)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: -10)
            $0.alpha = 0.0
        })
        view.addSubview(statusBar)
        self.statusBarView = statusBar
        
        statusBar.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(20)
        })
        
        let tabbarView = UIView().then {
            $0.backgroundColor = UIColor(hexString: "0xC36A6A").lighter()
        }
        self.tabbarView = tabbarView
        view.addSubview(tabbarView)
        
        tabbarView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(49.00)
        }
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
            $0.delegate = self
            $0.dataSource = self
            $0.bounces = true
            $0.isScrollEnabled = true
            $0.contentInset = UIEdgeInsets(top: 409, left: 0, bottom: 0, right: 0)
            $0.contentOffset = CGPoint(x: 0, y: -409)
            $0.backgroundColor = UIColor(hexString: "0x232329")
        }
        
        view.insertSubview(tableView!, at: 0)
        tableView?.snp.makeConstraints({
            $0.edges.equalTo(view)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GankJson.fetchImages(gankType: .welfare) { [weak weakSelf = self] in
            if let iJ = $0 {
                weakSelf?.resultJson = iJ
            }
        }
    }
    
    deinit {
        tableView?.delegate = nil
        tableView?.dataSource = nil
    }
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.000
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.00
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58.0
    }
}

extension RootViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let currentOffsetY = scrollView.contentOffset.y + 409.0
            if currentOffsetY > 0 && currentOffsetY < 340 {
                self.topScrollView?.snp.updateConstraints({
                    $0.top.equalTo(view.snp.top).offset(-currentOffsetY)
                })
            }
            else if currentOffsetY >= 340 {
                self.topScrollView?.snp.updateConstraints({
                    $0.top.equalTo(view.snp.top).offset(-340)
                })
            } else {
                self.topScrollView?.snp.updateConstraints({
                    $0.top.equalTo(view.snp.top)
                })
            }
            
            if currentOffsetY > 20 {
//                UIApplication.shared.statusBarStyle = .default
                UIApplication.shared.isStatusBarHidden = false
                statusBarView?.alpha = min(1.0, max(0.0, currentOffsetY/100))
            }
            else if currentOffsetY <= 0 {
//                UIApplication.shared.statusBarStyle = .lightContent
                UIApplication.shared.isStatusBarHidden = true
                statusBarView?.alpha = 0.0
            }
        }
    }
}
extension UIColor {
    class var gk_random: UIColor {
        let r = CGFloat(Double(arc4random_uniform(256)) / 256.0)
        let g = CGFloat(Double(arc4random_uniform(256)) / 256.0)
        let b = CGFloat(Double(arc4random_uniform(256)) / 256.0)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
