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
import SnapKit


class WelfareViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var noticeView: QCNoticeView!
    var customRefresh: CustomRefreshControl!
    var page: Int = 1 {
        didSet {
//            self.collectionView.reloadData()
        }
    }
    var indexPath: NSIndexPath?  /// 用了记录点击了哪一个 indexPath

    var welfareResults: [SortResult]! {
        didSet {
            collectionView.reloadData()
        }
    }
    var type: URLType! {
        didSet {
            loadDataFromRealm()
        }
    }
    private lazy var modalDelegate = ScaleTransition()

    weak var rightButton: UIButton?

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 添加刷新控件
        let rightView = UIButton(frame: CGRect.zero)

        rightView.setImage(UIImage(named: "refresh"), forState: .Normal)
        rightView.setImage(UIImage(named: "refresh_highlighted"), forState: .Highlighted)

        rightView.tintColor = UIColor.blackColor()

        rightView.sizeToFit()
        rightView.addTarget(self, action: #selector(fetchData), forControlEvents: .TouchUpInside)
        rightButton = rightView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)

        view.addSubview(collectionView)

        customRefresh = CustomRefreshControl()

        collectionView.addSubview(customRefresh)

        self.automaticallyAdjustsScrollViewInsets = false

        // show notice View
        let noticeView = QCNoticeView.loadNoticeView()
        noticeView.delegate = self
        self.view.addSubview(noticeView)
        self.noticeView = noticeView
        // 加载数据
//        loadData()
        type = URLType.welfare

        fetchData()
    }

    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)

        /**
         * 隐藏navigationBar
         */
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)

        // set noticeView

        noticeView.snp.makeConstraints(closure: { (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.top.equalTo(self.view.snp.top).offset(128)
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(200)
        })

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)

    }

    /**
     load data form realm
     */
    private func loadDataFromRealm() {
        if welfareResults != nil {
            welfareResults.removeAll()
        }
        var rs = [SortResult]()
        let results = SortResult.currentResult(15 * page, type: type.rawValue)
        for result in results {
            rs.append(result)
        }
        self.welfareResults = rs
    }
    @objc private func fetchData() {
        rotateRightItem()
        let manager = SortNetWorkManager.sortNetwordSharedInstance
        manager.fetchSortData(type, page: page) { (finished) in
            self.loadDataFromRealm()

            if self.customRefresh.refreshing {
                self.customRefresh.endAnimation()
            }
            self.rightButton?.layer.removeAllAnimations()
        }
    }

    func rotateRightItem() {
        // 添加旋转动画
        let rotationAnimation = CABasicAnimation()
        rotationAnimation.keyPath = "transform.rotation"
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = M_PI
        rotationAnimation.duration = 0.5

        rotationAnimation.repeatCount = MAXFLOAT

        self.rightButton?.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }


    // MARK: - lazy

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = Common.Screen_width * 0.5 - 1.0
        layout.itemSize = CGSizeMake(width, width)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0

        let cFrame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.size.width, height: self.view.bounds.height - 36)

        let collectionView: UICollectionView = UICollectionView(frame: cFrame, collectionViewLayout: layout)

        collectionView.backgroundColor = Common.navigationBarBackgroundColor

        collectionView.contentInset = UIEdgeInsetsZero

        collectionView.dataSource = self

        collectionView.delegate = self

        // 从nib中加载cell
        collectionView.registerNib(UINib.init(nibName: "WelfareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Common.welfareCellID)

        return collectionView
    }()

}
// MARK: - UICollectionViewDataSource
extension WelfareViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return welfareResults.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Common.welfareCellID, forIndexPath: indexPath) as! WelfareCollectionViewCell

        if indexPath.item == (welfareResults.count-1) {
            if page < 5 {
                if SortNetWorkManager.sortNetwordSharedInstance.isRechalble {
                    page += 1
                    fetchData()
                }
            } else {
                HUD.flash(.LabeledError(title: "", subtitle: "没有更多福利了！"), delay: 1.3)
            }
        }
        
        /**
         *  避免数组越界
         */

        if welfareResults.count > 0 {
            cell.welfareResult = welfareResults[indexPath.row]
        }
        /**
         *  通过app 审核的关键
         */
        if QCUserDefault.passed == "1" {
            if indexPath.row % 3 == 0 && indexPath.row != 0 {
            if let url = NSURL(string: Common.manImageURLs[Int(arc4random_uniform(4))]) {
                    cell.meiziImageView.kf_setImageWithURL(url)
                }
            }

        }

        return cell
    }
}

extension WelfareViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WelfareCollectionViewCell
        self.indexPath = indexPath
        let showWealfareVC = ShowWelfareViewController()
//        showWealfareVC.result = self.results[indexPath.item]
        showWealfareVC.result = self.welfareResults[indexPath.item]
        showWealfareVC.imageSize = cell.meiziImageView.image?.size

        showWealfareVC.transitioningDelegate = modalDelegate
        showWealfareVC.modalPresentationStyle = .Custom
        self.presentViewController(showWealfareVC, animated: true) {}
    }

    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WelfareCollectionViewCell

        UIView.animateWithDuration(0.09) {
            cell.alphaView.alpha = 0.0
        }
    }

    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WelfareCollectionViewCell

        UIView.animateWithDuration(0.09) {
            cell.alphaView.alpha = 0.5
        }
    }

}

extension WelfareViewController {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if customRefresh.refreshing {
            customRefresh.startAnimation()
//            self.loadData()
            self.fetchData()

        }
    }
}
extension WelfareViewController: QCNoticeViewDelegate {
    func noticeViewDidClickTryToRefreshButton(noticeView: QCNoticeView, sender: UIButton) {
//        loadData()
        self.fetchData()
    }
}
