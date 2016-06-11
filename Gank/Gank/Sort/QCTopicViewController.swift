//
//  QCTopicViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/9.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Alamofire

class QCTopicViewController: UITableViewController {


    // MARK: - URL相关

    typealias CompletedHandler = (root: RootClass?) -> Void
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


    /**
     网络请求

     - parameter completedHandler: 得到数据后待处理的闭包。root: 包含数据的RootClass的实例
     */
    func fectchData(completedHandler: CompletedHandler) {
        let dataRequest = Alamofire.request(.GET, urlStr, parameters: nil, encoding: .URL, headers: nil)

        dataRequest.responseJSON { (response) in
            guard let json = response.result.value else {
                print("error occurs")
                completedHandler(root: nil)
                return
            }

            let modal = RootClass(fromDictionary: json as! NSDictionary)
            completedHandler(root: modal)
        }
    }

    /**
     数据： results
     */
    lazy var results = [Result]()


    func loadData() {
        results.removeAll()

        fectchData { (root) in
            guard let root = root else {
                print("加载数据失败")
                return
            }

            for result in root.results {
                self.results.append(result)
            }

            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellID")

        loadData()

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
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID", forIndexPath: indexPath)
        cell.textLabel?.text = results[indexPath.row].desc
        return cell
    }

}