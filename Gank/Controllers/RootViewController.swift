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
    var tabbarView: TabbarView?
    var topScrollView: TopScrollView?
    var statusBarView: UIView?
    var refreshControl: UIRefreshControl?
    var resultJson: GankImageModel? {
        didSet {
            topScrollView?.imageJson = resultJson
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isStatusBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.clear
    
        navigationController?.do({
//            $0.navigationBar.shadowImage = UIImage()
//            $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
            $0.setNavigationBarHidden(true, animated: false)
        })
        
        let topScrollView = TopScrollView().then({ _ in
//            $0.delegate = self
        })
        topScrollView.addedTo(view: view)
        self.topScrollView = topScrollView
        topScrollView.makeConstraints()
        
        let statusBar = UIView().then({
            $0.backgroundColor = UIColor(white: 1.0, alpha: 0.88)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 10)
            $0.layer.shadowRadius = 20.0
            $0.layer.shadowOpacity = 1.0
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
        
        let tabbarView = TabbarView().then({
            $0.delegate = self
        })
        self.tabbarView = tabbarView
        view.addSubview(tabbarView)
        
        tabbarView.snp.makeConstraints {
            $0.top.equalTo(topScrollView.snp.bottom)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.height.equalTo(49.00)
        }
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
            $0.delegate = self
            $0.dataSource = self
            $0.bounces = true
            $0.isScrollEnabled = true
            $0.contentInset = UIEdgeInsets(top: 329, left: 0, bottom: 0, right: 0)
            $0.contentOffset = CGPoint(x: 0, y: -329)
            $0.backgroundColor = UIColor(hexString: "0x232329")
            if #available(iOS 10.0, *) {
                $0.refreshControl = UIRefreshControl().then({
                    $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
                })
            }
        }
        
        view.insertSubview(tableView!, at: 0)
        tableView?.snp.makeConstraints({
            $0.edges.equalTo(view)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GankImageModel.fetchImages(gankType: .welfare) { [weak weakSelf = self] in
            weakSelf?.resultJson = $0
        }
    }
    
    deinit {
        tableView?.delegate = nil
        tableView?.dataSource = nil
    }
    
    func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) { 
            if #available(iOS 10.0, *) {
                self.tableView?.refreshControl?.endRefreshing()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension RootViewController: TabbarViewDelegate {
    func tabbarView(tabbarView: TabbarView, didSeleted item: GankTabbarItem, with index: Int) {
        if #available(iOS 10.0, *) {
//            self.tableView?.refreshControl?.endRefreshing()
        } else {
            // Fallback on earlier versions
        }
    }
    func tabbarView(tabbarView: TabbarView, didClicked item: GankTabbarItem, with doubleClicked: Bool) {
        if doubleClicked == true {
//            let indexPath = IndexPath(item: 0, section: 0)
//            self.tableView?.scrollToRow(at: indexPath, at: .none, animated: false)
            self.tableView?.contentOffset = CGPoint(x: 0, y: -64 + tableView!.contentOffset.y)
            if #available(iOS 10.0, *) {
                self.tableView?.refreshControl?.beginRefreshing()
                
            } else {
                // Fallback on earlier versions
            }
        }
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
            let currentOffsetY = scrollView.contentOffset.y + 329.0
            if currentOffsetY > 0 && currentOffsetY < 260 {
                self.topScrollView?.snp.updateConstraints({
                    $0.top.equalTo(view.snp.top).offset(-currentOffsetY)
                })
            }
            else if currentOffsetY >= 260 {
                self.topScrollView?.snp.updateConstraints({
                    $0.top.equalTo(view.snp.top).offset(-260)
                })
            } else {
                self.topScrollView?.snp.updateConstraints({
                    $0.top.equalTo(view.snp.top)
                })
            }
            
            if currentOffsetY > 20 {
                UIApplication.shared.isStatusBarHidden = false
                statusBarView?.alpha = min(1.0, max(0.0, currentOffsetY/100))
            }
            else if currentOffsetY <= 0 {
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
