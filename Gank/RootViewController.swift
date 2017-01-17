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
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isStatusBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
    
        self.navigationController?.do({
            $0.navigationBar.shadowImage = UIImage()
            $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
        })
        
        bgScrollView = UIScrollView().then({
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = UIColor.white
//            $0.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 264)
        })
        view.addSubview(bgScrollView!)
        
        bgScrollView?.snp.makeConstraints({
            $0.top.equalTo(view.snp.top)
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottom)
        })
        
        let scrollView = UIScrollView().then({
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = false
            $0.alwaysBounceVertical = false
            $0.backgroundColor = UIColor.blue
        })
        
        bgScrollView?.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.left.equalTo(bgScrollView!.snp.left)
            $0.top.equalTo(bgScrollView!.snp.top)
//            $0.right.equalTo(bgScrollView.snp.right)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(220.0)
        }
        
        let tabbarView = UIView().then {
            $0.backgroundColor = UIColor.yellow
        }
        bgScrollView?.addSubview(tabbarView)
        
        tabbarView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.left.equalTo(bgScrollView!.snp.left)
//            $0.right.equalTo(bgScrollView.snp.right)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(44.00)
        }
        
        tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
            $0.delegate = self
            $0.dataSource = self
            $0.bounces = true
            $0.backgroundColor = UIColor(hexString: "0xff0f00").lighter()
//            $0.contentInset = UIEdgeInsets(top: 264, left: 0, bottom: 0, right: 0)
//            $0.contentOffset = CGPoint(x: 264, y: 0)
        }
        
//        view.addSubview(tableView!)
        bgScrollView?.insertSubview(tableView!, at: 0)
        
        tableView?.snp.makeConstraints({
            $0.left.equalTo(bgScrollView!.snp.left)
            $0.top.equalTo(tabbarView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(UIScreen.main.bounds.height)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bgScrollView?.contentSize = CGSize(width: UIScreen.main.bounds.width, height: tableView!.contentSize.height + 264)
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
}
