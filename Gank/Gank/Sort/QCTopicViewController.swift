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
import SnapKit


class QCTopicViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    let sortNetworkManager = SortNetWorkManager.sortNetwordSharedInstance

    var sortResults = [SortResult]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    // MARK: - URL相关

    var type: URLType? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var page: Int = 1 {
        didSet {
            fetchData()
        }
    }

    // MARK: - Lazy

    var customRefreshControl: CustomRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false

        customRefreshControl = CustomRefreshControl()
        view.addSubview(self.customRefreshControl)

        loadDataFromRealm()

        fetchData()

        tableView.registerClass(SortCell.self, forCellReuseIdentifier: "topicCellID")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .None
        self.tabBarController?.tabBar.hidden = false
        page = 1
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if animated { // 表示push进去下一vc
            self.tabBarController?.tabBar.hidden = true
        }
        self.customRefreshControl.endAnimation()
    }

    private func fetchData() {
        sortNetworkManager.fetchSortData(self.type!, page: page) {
            finished in
            if self.customRefreshControl != nil {
                self.customRefreshControl.endAnimation()
            }
            self.loadDataFromRealm()
            self.tableView.reloadData()
        }
    }

}
// MARK: - 这里用代理有点问题。所以不使用这个
extension QCTopicViewController {
    /*
    func fetchSuccess() {
        self.customRefreshControl.endAnimation()
        loadDataFromRealm()
    }
    func fetchFalied() {
        self.customRefreshControl.endAnimation()
        loadDataFromRealm()
    }
     */
    func loadDataFromRealm() {
        sortResults.removeAll()
        tableView.reloadData()
        let results = SortResult.currentResult(15 * page, type: type!.rawValue)
        for result in results {
            sortResults.append(result)
        }
        tableView.reloadData()
    }
}

extension QCTopicViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortResults.count
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellID = "topicCellID"
//        let cell = SortCell(style: .Default, reuseIdentifier: cellID)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! SortCell

        if indexPath.row == sortResults.count - 1 {
            if page < 5 {
                page += 1
            } else {
                HUD.flash(.LabeledError(title: "没有更多了。", subtitle: ""), delay: 0.8)
            }
        }
        if sortResults.count > 0 {
            cell.sortResult = sortResults[indexPath.row]
        }

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        if sortResults.count > 0 {
            let result = sortResults[indexPath.row]
            let descLabelHeight = SortResult.stringToSize(14, str: result.desc! as NSString).height
            let timeLabelHeight = SortResult.stringToSize(10, str: result.publishedAt! as NSString).height
            let cellHeight = Float(descLabelHeight) + Float(timeLabelHeight) + 30
            
            return CGFloat(cellHeight)
        } else {
            return 56.0
        }

    }
}

extension QCTopicViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let webVC = UIStoryboard(name: "QCWebViewController", bundle: nil).instantiateInitialViewController() as! QCWebViewController
        let sortResult = sortResults[indexPath.row]

        webVC.url = sortResult.url
        self.navigationController?.pushViewController(webVC, animated: true)

    }
}

extension QCTopicViewController {
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if customRefreshControl.refreshing {
            customRefreshControl.startAnimation()
            fetchData()
        }
    }
}