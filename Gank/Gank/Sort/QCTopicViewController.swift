//
//  QCTopicViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/9.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class QCTopicViewController: UITableViewController {


    // MARK: - URL相关

//    typealias CompletedHandler = (root: RootClass?) -> Void
    var urlStr: String = ""

    var type: URLType? {
        didSet {
            urlStr = "http://gank.io/api/data/" + type!.rawValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "/20/1"
        }
    }

    var page: Int = 1 {
        didSet {
            urlStr = "http://gank.io/api/data/" + type!.rawValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + "/20/" + "\(page)"
        }
    }

    // MARK: - Lazy
    /**
     数据： results
     */
    lazy var results = [Result]()
    lazy var customRefreshControl = CustomRefreshControl()
    lazy var alamofireManager = AlamofireManager()

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellID")

        self.automaticallyAdjustsScrollViewInsets = false


        view.addSubview(self.customRefreshControl)


    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .None

        loadData()
    }

    /**
     获取数据
     */
    func loadData() {
        page = 1
        results.removeAll()
        HUD.flash(.LabeledProgress(title: "数据加载ing", subtitle: ""),delay: 3.0)
        alamofireManager.fectchTopicData(urlStr) { (rootClass) in
            guard let root = rootClass else {
                HUD.flash(.LabeledError(title: "数据加载失败", subtitle: "请稍后再试~"),delay: 1.0)
                HUD.hide()
                return
            }

            for result in root.results {
                self.results.append(result)
            }

            self.customRefreshControl.endAnimation()

            self.tableView.reloadData()

            HUD.hide()
        }
    }

    func loadMoreData() {


        alamofireManager.fectchTopicData(urlStr) { (rootClass) in
            guard let root = rootClass else {
                HUD.flash(.LabeledError(title: "加载数据失败", subtitle: ""), delay: 1.0)
                return
            }
            for result in root.results {
                self.results.append(result)
            }
            self.tableView.reloadData()

        }
    }
}
extension QCTopicViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellID = "topicCellID"
        let cell = SortCell(style: .Default, reuseIdentifier: cellID)
        if indexPath.row == results.count-1 {
            if page < 5 {
                page += 1
                loadMoreData()
            } else {
                HUD.flash(.LabeledError(title: "没有更多数据了", subtitle: ""), delay: 0.5)
            }
        }
        /**
         *  避免数组越界
         */
        if results.count > 0 {
            cell.result = results[indexPath.row]
        }

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if results.count > 0 {
            return results[indexPath.row].cellHeight
        }else {
            return 56.0
        }

    }
}

extension QCTopicViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let result = results[indexPath.row]
        let webVC = UIStoryboard(name: "QCWebViewController", bundle: nil).instantiateInitialViewController() as! QCWebViewController

        webVC.url = result.url

        self.navigationController?.pushViewController(webVC, animated: true)

    }
}

extension QCTopicViewController {
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if customRefreshControl.refreshing {
            customRefreshControl.startAnimation()
            self.loadData()
        }
    }
}