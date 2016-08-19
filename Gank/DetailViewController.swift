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
import MonkeyKing

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

    // MARK: - Properties
    var dateString: String! {
        didSet {
            urlString = "http://gank.io/api/day/" + dateString
        }
    }

    var urlString = String()
    var imageUrl = String() {
        didSet {
            imageView.kf_setImageWithURL(NSURL(string: imageUrl)!)
        }
    }
    var result: EverydayResult?

    var dayResult: DayResult!
    var dayResultCategory: [String:[CategoryResult]]! {
        didSet {
            self.tableView.reloadData()
        }
    }

    let originOffsetY = -1 * UIScreen.mainScreen().bounds.height * 0.66

    // MARK: - Lazy
    lazy var imageView :UIImageView = {
        let imageView = UIImageView()
//        imageView.userInteractionEnabled = true
        imageView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 0.66)
        imageView.contentMode = UIViewContentMode.ScaleToFill

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImage))
        imageView.addGestureRecognizer(tapGesture)


        return imageView
    }()

    lazy var tableView: UITableView = {

        let tableView: UITableView = UITableView(frame: CGRect.zero, style: .Grouped)

        tableView.frame = UIScreen.mainScreen().bounds
        tableView.contentInset = UIEdgeInsets(top: self.imageView.height, left: 0, bottom: 36, right: 0)
        tableView.separatorStyle = .None

        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerClass(CategoryCell.self, forCellReuseIdentifier: String(CategoryCell))

        return tableView

    }()

    // MARK: - Outlets
    @IBOutlet weak var sharedButton: UIButton!
    @IBOutlet weak var shadowImageView: UIImageView!

    // MARK: - Private functions
    @objc private func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @objc private func sharedButtonClicked() {

        guard let sharedImage = imageView.image else {
            return
        }
        let todayUrlStr = "http://gank.io/" + dateString
        guard let todayUrl = NSURL(string: todayUrlStr) else {
            return
        }

        let info = MonkeyKing.Info(title: NSLocalizedString("来自Gank, 一款追求极致的干货集中营客户端", comment: ""), description: NSLocalizedString("", comment: ""), thumbnail: UIImage(named: "icon"), media: MonkeyKing.Media.URL(todayUrl))

        let sessionMessage = MonkeyKing.Message.WeChat(.Session(info: info))

        let wechatSession = WeChatActivity(type: .Session, message: sessionMessage) { (result) in
            print("success in share to wechat session")
        }

        let timeLineMessage = MonkeyKing.Message.WeChat(.Timeline(info: info))
        let wechatTimeLine = WeChatActivity(type: .Timeline, message: timeLineMessage) { (result) in
            print("success in share to wechat timeline")
        }

        let activityVC = UIActivityViewController(activityItems: [sharedImage, todayUrlStr], applicationActivities: [wechatSession, wechatTimeLine])
        activityVC.excludedActivityTypes = [UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePrint]

        self.presentViewController(activityVC, animated: true, completion: nil)
    }

    @objc private func showImage() {
        let showImageVC = ShowWelfareViewController()

//        showImageVC.imageUrl = self.imageUrl

        self.presentViewController(showImageVC, animated: true, completion: nil)
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.automaticallyAdjustsScrollViewInsets = false

//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), highlightedImage: UIImage(named: "back_highlighted"), target: self, action: #selector(back))
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), highlightedImage: UIImage(named: "back_highlighted"), target: self, action: #selector(back))

        let rightButton = UIButton(type: .System)
        rightButton.width = 22
        rightButton.height = 33
        rightButton.setImage(UIImage(named: "share"), forState: .Normal)
        rightButton.setImage(UIImage(named: "share_highlighted"), forState: .Highlighted)
        rightButton.contentMode = .ScaleAspectFill

        rightButton.tintColor = UIColor.blackColor()
        rightButton.addTarget(self, action: #selector(sharedButtonClicked), forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
    }

    private func fetchDataFromNet() {
        fetchDataFromRealm()

        DayNetworkService.dayManager.fetchDayData(urlString) { (finished) in
            if finished {
                self.fetchDataFromRealm()
            }
        }
    }
    private func fetchDataFromRealm() {
        dayResult = nil
        dayResultCategory = nil

        dayResult = DayResult.currentDayResult(urlString)

        dayResultCategory = DayResult.currentDayResultCategory(urlString)

        self.tableView.reloadData()
    }


    private func setupSubviews() {
        /**
         添加tableView
         */
        view.insertSubview(tableView, atIndex: 0)

        /**
         添加一个imageView到scrollView上
         */

        view.insertSubview(imageView, aboveSubview: tableView)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)


        setupSubviews()

        //透明状态栏
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        fetchDataFromNet()

        if imageView.image == nil {
            imageView.kf_setImageWithURL(NSURL(string: imageUrl)!)
        }
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        dayResultCategory = nil
        dayResult = nil
        imageView.image = nil
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)


        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = nil

    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    @IBAction func dismiss(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DetailViewController: UITableViewDelegate {

    // 设置header和footer的高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let dr = dayResult else {
            return 0.001
        }
        let category = dr.category[indexPath.section]
                /// 避免空值
        guard let catResult = dayResultCategory[category.type!] else {
            return 56
        }
        let result = catResult[indexPath.row]

        let descLabelHeight = SortResult.stringToSize(14, str: result.desc! as NSString).height
        let timeLabelHeight = SortResult.stringToSize(10, str: result.publishedAt! as NSString).height
        let cellHeight = Float(descLabelHeight) + Float(timeLabelHeight) + 10

        return CGFloat(cellHeight)
    }
    /**
     *  选中cell的操作
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category = dayResult.category[indexPath.section].type
        guard let catResult = dayResultCategory[category!] else {
            return
        }
        let result = catResult[indexPath.row]

        let webVC = UIStoryboard(name: "QCWebViewController", bundle: nil).instantiateViewControllerWithIdentifier("QCWebViewController") as! QCWebViewController
        webVC.url =  result.url

        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}
extension DetailViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let dr = dayResult else {
            return 0
        }
        return dr.category.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        guard let dr = dayResult else {
            return 0
        }
        guard let drc = dayResultCategory else {
            return 0
        }
        let category = dr.category[section]

        let categories = drc[category.type!]
        return categories!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(CategoryCell), forIndexPath: indexPath) as! CategoryCell

        guard let dr = dayResult else {
            return cell
        }
        let category = dr.category[indexPath.section]
        if let cr = dayResultCategory[category.type!] {
            cell.everydayResult = cr[indexPath.row]
        }
        return cell
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let dr = dayResult else {
            return nil
        }
        return dr.category[section].type
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

extension DetailViewController: UINavigationControllerDelegate {

}