//
//  QCEveryDayGnakViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class QCEveryDayGnakViewController: UIViewController, UICollectionViewDataSource {



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.automaticallyAdjustsScrollViewInsets = false

        self.view.addSubview(self.collectionView)

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), highlightedImage: UIImage(named: "refresh"), target: self, action: #selector(loadData))


        loadData()
        


    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 设置导航栏透明
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 设置导航栏为nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - private function
    func loadMoreData() {
        print("添加了加载更多数据")
    }
    @objc private func loadData() {

        self.results.removeAll()

        

        // Alamofire
        AlamofireManager.sharedInstance.type = URLType.welfare

        AlamofireManager.sharedInstance.fetchDataForWelfare { (rootClass) in
            guard let root = rootClass else {
                print("没有获取到数据")
                return
            }

            self.results = root.results
            self.results.sortInPlace({ (r1, r2) -> Bool in
                r1.publishedAt > r2.publishedAt  // 对首页的数据进行排序
            })
            self.collectionView.reloadData()


            
            
        }
    }

    @objc private func didClickRightBarButton() {
        /// 重新加载数据
        self.loadData()
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

        collectionView.contentInset = UIEdgeInsetsMake(44, 0, 40, 0)

        collectionView.pagingEnabled = false

        return collectionView

    }()
    lazy var createString = String()
    lazy var results = [Result]()

    lazy var destVC: DetailViewController = {

        let destVC = DetailViewController()
        return destVC
    }()
    
}

extension QCEveryDayGnakViewController {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Common.everydayGankCellID, forIndexPath: indexPath) as! QCEverydayGankCell
        if let url = NSURL(string: results[indexPath.item].url) {
            cell.imageView.kf_setImageWithURL(url)
        }
        // 处理时间
        let formatterToDate = NSDateFormatter()
        formatterToDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let str = results[indexPath.item].publishedAt
        let createTime = formatterToDate.dateFromString(str)

        let formatterToString = NSDateFormatter()
        formatterToString.dateFormat = "yyyy/MM/dd"

        // 处理日期 
        var timeStr: String!

        let components = NSDate().deltaFromDate(createTime!)
        if components.year == 0 {
            if components.month == 0 {
                if components.day == 0 {
                    timeStr = "今天"
                } else if components.day == 1 {
                    timeStr = "昨天"
                } else if components.day == 2 {
                    timeStr = "前天"
                } else {
                    timeStr = "\(components.day)天前"
                }
            } else {
                timeStr = formatterToString.stringFromDate(createTime!)
            }
        }

        cell.timeLabel.text = "#" + timeStr + "#"

        cell.sourceLabel.text = "来源：" + results[indexPath.item].who

        return cell
    }
}

extension QCEveryDayGnakViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /**
         *  把时间传给下一个VC
         */

        // 处理时间
        let formatterToDate = NSDateFormatter()
        formatterToDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let str = results[indexPath.item].publishedAt
        let createTime = formatterToDate.dateFromString(str)

        let formatterToString = NSDateFormatter()
        formatterToString.dateFormat = "yyyy/MM/dd"
        
        self.destVC.dateString = formatterToString.stringFromDate(createTime!)
        self.navigationController?.pushViewController(self.destVC, animated: true)
    }
}

