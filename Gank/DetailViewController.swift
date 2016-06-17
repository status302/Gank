//
//  DetailViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/11.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import PKHUD


 /**
    1. 添加下拉放大的背景
    2. 添加类qq分组的insert和delete
    3. 跳转到webView上
    4. 添加分享功能
 
 */

/***
    QQ列表的展开效果：
    1. 设置tableView的类型为Grouped
    2. 和点击相关的方法：
        1. willSelect
        2. didSelect
        3. willDeselect
        4. diddeselect
        
        点击事件的发生顺序：
            willSelect
            willDeselect
            didDeselect
            didSelect
 
        删除和添加cell的方法是：
            insertRowsAtIndexPaths
            deleteRowsAtIndexPaths

 */

class DetailViewController: UIViewController {

    typealias CompletedHandler = (rootClass: EverydayRootClass?)->(Void)
    typealias LoadedData = (finished: Bool)->Void

    // MARK: - Properties
    var dateString: String! {
        didSet {
            urlString = "http://gank.io/api/day/" + dateString
        }
    }
    lazy var results = [String:[EverydayResult]]()
    lazy var categories = [String]()
    var urlString = String()
    var imageUrl = String() {
        didSet {
            imageView.kf_setImageWithURL(NSURL(string: imageUrl)!)
        }
    }
    let originOffsetY = -1 * UIScreen.mainScreen().bounds.height * 0.66

    // MARK: - Lazy
    lazy var imageView :UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 0.66)
        imageView.contentMode = UIViewContentMode.ScaleToFill
        return imageView
    }()

    lazy var tableView: UITableView = {

        let tableView: UITableView = UITableView()

        tableView.frame = UIScreen.mainScreen().bounds
        tableView.contentInset = UIEdgeInsets(top: self.imageView.height, left: 0, bottom: 36, right: 0)
        tableView.separatorStyle = .None

        tableView.sectionHeaderHeight = 0

        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "detailCell")

        return tableView

    }()

    // MARK: - Outlets

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.

        self.automaticallyAdjustsScrollViewInsets = false



    }

    private func setupSubviews() {
        /**
         添加tableView
         */
//        view.addSubview(tableView)
        view.insertSubview(tableView, atIndex: 0)

        /**
         添加一个imageView到scrollView上
         */

//        view.addSubview(imageView)
        view.insertSubview(imageView, aboveSubview: tableView)


//        scrollView.contentSize = tableView.contentSize

    }

    private func loadData(finishedLoad: LoadedData) {
        self.results.removeAll()

        self.fetchDataManager { (rootClass) -> (Void) in
            guard let root = rootClass else {
                return
            }

            self.results = root.results
            self.categories = root.categories
            self.tableView.reloadData()
            finishedLoad(finished: true)
        }
    }

    private func fetchDataManager(completedHandler: CompletedHandler) {
        HUD.flash(.LabeledProgress(title: "正在玩命加载中", subtitle: ""))
        Alamofire.request(.GET, urlString, parameters: nil, encoding: .URL, headers: nil).responseJSON { (response) in
            guard let json = response.result.value else {
                completedHandler(rootClass: nil)
                return
            }

            let model = EverydayRootClass(fromDictionary: json as! NSDictionary)

            completedHandler(rootClass: model)
            HUD.hide()

        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        setupSubviews()

        //透明状态栏
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()


        loadData { (finished) in
            if finished {
//                print(self.results["福利"]![0].url)
                self.imageUrl = self.results["福利"]![0].url

            }
        }


    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.imageView.image = nil
    }

    @IBAction func dismiss(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DetailViewController: UITableViewDelegate {
    /**
        1.
     */
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        // 返回的indexPath表示即将要选中的indexPath

        return indexPath

    }

    /**
    3.
    */
    func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        // 返回的indexPath表示即将被取消选中的indexPath
        return indexPath
    }

    /**
        2.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        // 模拟只添加一行数据
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        categories.insert("hahahahha", atIndex: indexPath.row + 1)
        tableView.reloadData()
        tableView.endUpdates()

    }

    /**
        4.
     */
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {


    }

}
extension DetailViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var extra = 0

        return categories.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

}
extension DetailViewController {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y

        let delta = contentOffsetY - originOffsetY
        var height = UIScreen.mainScreen().bounds.height * 0.66 - delta * 0.5
        if height <= 100 {
            height = 100.0
        }

        if delta < 0 {
            imageView.y = 0.0001
        } else {
            imageView.y = -delta * 0.5
        }

        imageView.height = height
    }
}