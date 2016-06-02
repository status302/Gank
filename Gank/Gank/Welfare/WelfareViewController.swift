//
//  WelfareViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/23.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Kingfisher


class WelfareViewController: UIViewController {

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refreshBarButtonDidClick))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(refreshBarButtonDidClick))

        view.addSubview(collectionView)

        self.automaticallyAdjustsScrollViewInsets = false

        // 加载数据
        loadData()

    }

    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        /**
         * 隐藏navigationBar
         */
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)

    }

    // private functions
    @objc private func refreshBarButtonDidClick() {
        print("did click refresh button")

        loadData()

    }

    private func loadData() {
        // 每次加载数据之前都要将数据置空
        results.removeAll()

        AlamofireManager.sharedInstance.fetchDataForWelfare { (rootClass) in
            guard let root = rootClass else {
                return
            }

            self.results = root.results
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

        collectionView.backgroundColor = UIColor.whiteColor()

        let refreshController = UIRefreshControl()

        refreshController.addTarget(self, action: #selector(WelfareViewController.refreshBarButtonDidClick), forControlEvents: .ValueChanged)



        collectionView.addSubview(refreshController)

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

        cell.result = results[indexPath.row]

        return cell
    }
}

extension WelfareViewController: UICollectionViewDelegate {


    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        print("shouldSelectItemAtIndexPath")

        return true
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let showWealfareVC = ShowWelfareViewController()
        showWealfareVC.result = self.results[indexPath.item]
        self.presentViewController(showWealfareVC, animated: true) {
            print("已经成功-------------")
        }
    }

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        print("didHighlightItemAtIndexPath")
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
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print("-----scrollView contentOffset.y is : \(scrollView.contentOffset.y)")

        let radio:CGFloat = abs(scrollView.contentOffset.y / 60.0)
//        refreshView.alpha = radio
        view.layoutIfNeeded()

    }
}
