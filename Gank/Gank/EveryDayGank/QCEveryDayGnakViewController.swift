//
//  QCEveryDayGnakViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import PKHUD
import SnapKit
import Kingfisher

class QCEveryDayGnakViewController: UIViewController, UICollectionViewDataSource {

    weak var rightButton: UIButton?
//    lazy var settingAnimator = GKShowSettingAnimator()
    var nView: QCNoticeView!
    var welfareResult = [SortResult]()
    var page: Int = 1 {
        didSet {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.initNavItemButton()

        self.automaticallyAdjustsScrollViewInsets = false

        self.view.addSubview(self.collectionView)


        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "setting"), highlightedImage: UIImage(named: "setting_highlighted"), target: self, action: #selector(showSettingButtonCicked))

        loadDataFromRealm()

        // show notice View 
        let noticeView = QCNoticeView.loadNoticeView()
        noticeView.delegate = self
        self.view.addSubview(noticeView)

        noticeView.snp.makeConstraints(closure: { (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top).offset(128)
            make.height.equalTo(200)
        })
        nView = noticeView
        self.loadDataFromNetwork()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // 设置导航栏透明
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        self.loadDataFromNetwork()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 设置导航栏为nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - private function
    private func initNavItemButton() {
        /// 添加刷新控件
        let rightView = UIButton(frame: CGRect.zero)

        rightView.setImage(UIImage(named: "refresh"), forState: .Normal)
        rightView.setImage(UIImage(named: "refresh_highlighted"), forState: .Highlighted)

        rightView.tintColor = UIColor.blackColor()

        rightView.sizeToFit()
        rightView.addTarget(self, action: #selector(loadDataFromNetwork), forControlEvents: .TouchUpInside)
        rightButton = rightView
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    func loadDataFromRealm() {
        if welfareResult.count != 0 {
            welfareResult.removeAll()
        }
        let currentResults = SortResult.currentResult(15, type: URLType.welfare.rawValue)
        for result in currentResults {
            welfareResult.append(result)
        }
        self.collectionView.reloadData()
    }
    func loadDataFromNetwork() {
        self.raotateRightItem()
        if !SortNetWorkManager.sortNetwordSharedInstance.isRechalble {
            self.rightButton?.layer.removeAllAnimations()
        }
        SortNetWorkManager.sortNetwordSharedInstance.fetchSortData(.welfare, page: page) { (finished) in
            if finished {
                self.loadDataFromRealm()
                self.rightButton?.layer.removeAllAnimations()
            }
        }
    }
    func showSettingButtonCicked() {
        // 在这里显示设置
        settingNav.transitioningDelegate = settingTransition
        settingNav.modalPresentationStyle = .Custom
        self.presentViewController(settingNav, animated: true, completion: nil)
    }
    func raotateRightItem() {
        UIView.animateWithDuration(0.5, delay: 0, options: .Repeat, animations: {
            self.rightButton?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }) { (finished) in  }

        let rotationAnimation = CABasicAnimation()
        rotationAnimation.keyPath = "transform.rotation"
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = M_PI
        rotationAnimation.duration = 0.5

        rotationAnimation.repeatCount = MAXFLOAT

        self.rightButton?.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }

    // MARK: - lazy
    lazy var collectionView: QCCollectionView = {

        let collectionView: QCCollectionView = QCCollectionView(frame: self.view.bounds, collectionViewLayout: QCCollectionViewLayout())

        collectionView.dataSource = self
        collectionView.delegate = self

        // background color
        collectionView.backgroundColor = Common.navigationBarBackgroundColor

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 20, 0)

        collectionView.pagingEnabled = false

        return collectionView

    }()
    lazy var createString = String()

    lazy var destVC: DetailViewController = {

        let destVC = DetailViewController()
        return destVC
    }()
    lazy var settingNav: GKSettingNavController = {
        let settingNav = UIStoryboard(name: "Setting", bundle: nil).instantiateInitialViewController() as! GKSettingNavController

        return settingNav
    }()
    lazy var settingTransition = GKSettingTransition()
}

extension QCEveryDayGnakViewController {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return welfareResult.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Common.everydayGankCellID, forIndexPath: indexPath) as! QCEverydayGankCell

        if welfareResult.count > 0 {
            cell.result = self.welfareResult[indexPath.item]
        }

        if QCUserDefault.passed == "1" {
            let randomInt = Int(arc4random_uniform(4))
            if let url = NSURL(string: Common.manImageURLs[randomInt]) {
                if indexPath.row % 3 == 1 {
                    cell.imageView.kf_setImageWithURL(url)
                }
            }
        }


        return cell
    }
}

extension QCEveryDayGnakViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /**
         *  把时间以 yyyy/MM/dd 形式传给下一个VC
         */

        // 处理时间
        let formatterToDate = NSDateFormatter()
        formatterToDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        let str = results[indexPath.item].publishedAt
        let str = welfareResult[indexPath.item].publishedAt
        let createTime = formatterToDate.dateFromString(str!)

        let formatterToString = NSDateFormatter()
        formatterToString.dateFormat = "yyyy/MM/dd"
        
        self.destVC.dateString = formatterToString.stringFromDate(createTime!)

        let welfare = welfareResult[indexPath.row]
        self.destVC.imageUrl = welfare.url!
        self.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(self.destVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}


extension QCEveryDayGnakViewController: QCNoticeViewDelegate {
    func noticeViewDidClickTryToRefreshButton(noticeView: QCNoticeView, sender: UIButton) {
        self.loadDataFromRealm()
    }
}
//extension QCEveryDayGnakViewController: UIViewControllerTransitioningDelegate {
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return GKSettingTransition()
//    }
//}

