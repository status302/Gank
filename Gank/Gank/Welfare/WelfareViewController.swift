//
//  WelfareViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/23.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
import SKPhotoBrowser


class WelfareViewController: UIViewController {

    var customRefresh: CustomRefreshControl!
    var page: Int = 1
    // MARK: - View life cycle


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refreshBarButtonDidClick))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(refreshBarButtonDidClick))

        view.addSubview(collectionView)

        customRefresh = CustomRefreshControl()

        collectionView.addSubview(customRefresh)

        self.automaticallyAdjustsScrollViewInsets = false

        // 加载数据
        loadData()

    }

    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)

        /**
         * 隐藏navigationBar
         */
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)

    }

    // private functions
    @objc private func refreshBarButtonDidClick() {
        print("did click refresh button")

        HUD.flash(.Label("哈哈哈，分享还没做好~"), delay: 1.2)

    }

    private func loadData() {
        // 每次加载数据之前都要将数据置空
        results.removeAll()
        page = 1
        AlamofireManager.sharedInstance.page = page

        AlamofireManager.sharedInstance.type = URLType.welfare

        AlamofireManager.sharedInstance.fetchDataForWelfare { (rootClass) in
            guard let root = rootClass else {
                return
            }

            self.results = root.results
            self.collectionView.reloadData()
        }

    }
    func loadMoreData() {
        AlamofireManager.sharedInstance.page = page

        AlamofireManager.sharedInstance.type = URLType.welfare

        AlamofireManager.sharedInstance.fetchDataForWelfare { (rootClass) in
            guard let root = rootClass else {
                return
            }
            for result in root.results {
                self.results.append(result)
            }
            self.collectionView.reloadData()
        }
    }

    // MARK: - lazy

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = Constants.Screen_width*0.5 - 1.0
        layout.itemSize = CGSizeMake(width, width)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0

        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)

        collectionView.backgroundColor = Constants.backgroundColor

//        let refreshController = UIRefreshControl()
//
//        refreshController.addTarget(self, action: #selector(WelfareViewController.refreshBarButtonDidClick), forControlEvents: .ValueChanged)
//
//
//
//        collectionView.addSubview(refreshController)

        collectionView.contentInset = UIEdgeInsetsZero

        collectionView.dataSource = self

        collectionView.delegate = self

        // 从nib中加载cell
        collectionView.registerNib(UINib.init(nibName: "WelfareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.welfareCellID)

        return collectionView
    }()

    lazy var results = [Result]()

}
// MARK: - UICollectionViewDataSource
extension WelfareViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.welfareCellID, forIndexPath: indexPath) as! WelfareCollectionViewCell

        if indexPath.item == (results.count-1) {
            if page < 5 {
                page += 1
                self.loadMoreData()
            } else {
                HUD.flash(.LabeledError(title: "", subtitle: "没有更多福利了！"), delay: 1.3)
            }

        }
        cell.result = results[indexPath.row]

        return cell
    }
}

extension WelfareViewController: UICollectionViewDelegate {


    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {

        return true
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let showWealfareVC = ShowWelfareViewController()
        showWealfareVC.result = self.results[indexPath.item]
        self.presentViewController(showWealfareVC, animated: true) {}
    }

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WelfareCollectionViewCell

        UIView.animateWithDuration(0.15) {
            cell.alphaView.alpha = 0.0
        }
    }

    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WelfareCollectionViewCell

        UIView.animateWithDuration(0.3) {
            cell.alphaView.alpha = 0.5
        }
    }

}

extension WelfareViewController {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if customRefresh.refreshing {
            if !customRefresh.isAnimating {
               customRefresh.startAnimation()
            }
        }
    }
}
