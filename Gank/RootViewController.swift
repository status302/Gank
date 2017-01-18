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
    var topScrollView: UIScrollView?
    var statusBarView: UIView?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .lightContent
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.clear
    
        self.navigationController?.do({
            $0.navigationBar.shadowImage = UIImage()
            $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
        })
        
        
        let scrollView = UIScrollView().then({
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = false
            $0.alwaysBounceVertical = false
            $0.contentSize = CGSize(width: view.frame.width * 5, height: 0)
            $0.backgroundColor = UIColor.blue
            $0.isPagingEnabled = true
            
            for index in 0..<5 {
                let contentView = UIView()
                contentView.frame = CGRect(x: CGFloat(index) * view.frame.width, y: 0, width: view.frame.width, height: 360.0)
                contentView.backgroundColor = UIColor.gk_random
                $0.addSubview(contentView)
            }
        })
        
        view.addSubview(scrollView)
        self.topScrollView = scrollView
        
        scrollView.snp.makeConstraints {
            $0.left.equalTo(view.snp.left)
            $0.top.equalTo(view.snp.top)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(360.0)
        }
        
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
        
        let refresh = UIRefreshControl().then({_ in 
            
        })
        
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
                UIApplication.shared.statusBarStyle = .default
                statusBarView?.alpha = min(1.0, max(0.0, currentOffsetY/100))
            }
            else if currentOffsetY <= 0 {
                UIApplication.shared.statusBarStyle = .lightContent
                statusBarView?.alpha = 0.0
            }
        }
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("++++")
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
