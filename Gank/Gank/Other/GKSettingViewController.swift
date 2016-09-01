//
//  GKSettingViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/8/30.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import MonkeyKing

protocol GKSettingDismissDelegate {
    func settingDismissNav(settingVC: GKSettingViewController, sender: AnyObject)
}

class GKSettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var delegate: GKSettingDismissDelegate?

    let titles = ["我的收藏", "应用设置", "推荐给朋友" , "给我评分", "邮件反馈", "版本", "关于"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        tableView.registerNib(UINib(nibName: GKSettingCell.nibName, bundle: nil), forCellReuseIdentifier: GKSettingCell.reuseIdentifier)

        setupNav()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func setupNav() {
        let titleLabel = UILabel()
        titleLabel.text = "设置"
        titleLabel.font = UIFont.font_dfphaib(size: 18)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }

    @IBAction func dismissButtonClicked(sender: AnyObject) {
        delegate?.settingDismissNav(self, sender: sender)
    }
    lazy var headerView: GKSettingHeaderView = {
        let header = GKSettingHeaderView.headerView()

        return header
    }()
}
extension GKSettingViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(GKSettingCell.reuseIdentifier, forIndexPath: indexPath) as! GKSettingCell

        cell.titleLabel.text = titles[indexPath.row]

        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.00
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 160.0
        }
        return 1.00
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40.00
        }
        return 1.00
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footLabel = UILabel()
        footLabel.text = "Copyright © 2016年 qiuncheng.com. All rights reserved."
        footLabel.font = UIFont.systemFontOfSize(10)
        footLabel.sizeToFit()
        footLabel.textAlignment = NSTextAlignment.Center
        return footLabel
    }
}

extension GKSettingViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0: /// 我的收藏
            
            break
        case 1:  /// 界面设置

            break
        case 2:  /// 推荐给朋友
            let sharedImage = UIImage(named: "240")

            guard let sharedUrl = NSURL(string: "https://itunes.apple.com/it/app/gank-da-zao-ji-zhi-degank.io/id1129157059?mt=8") else {
                return
            }
            let sharedUrlStr = "https://itunes.apple.com/it/app/gank-da-zao-ji-zhi-degank.io/id1129157059?mt=8"
            let sharedTitle = "Hi, 推荐一款@Qiuncheng打造干货分享的App, 叫做 \(GKApp.appName!), 快来下载吧！"
            let info = MonkeyKing.Info(title: NSLocalizedString("Hi, 推荐一款干货分享的App, 叫做 \(GKApp.appName!), 快来下载吧", comment: ""), description: NSLocalizedString("", comment: ""), thumbnail: sharedImage, media: MonkeyKing.Media.URL(sharedUrl))

            let weChatSessionMessage = MonkeyKing.Message.WeChat(.Session(info: info))
            let weChatFriendMessage = MonkeyKing.Message.WeChat(.Timeline(info: info))

            let sessionActivity = WeChatActivity(type: .Session, message: weChatSessionMessage, completionHandler: { (result) in
                print("\(result)")
            })

            let timelineActivity = WeChatActivity(type: .Timeline, message: weChatFriendMessage, completionHandler: { (result) in
                print("\(result)")
            })

            let activityVC = UIActivityViewController(activityItems: [sharedImage!, sharedUrl, sharedTitle, sharedUrlStr], applicationActivities: [timelineActivity, sessionActivity])

            activityVC.excludedActivityTypes = []
            self.presentViewController(activityVC, animated: true, completion: nil)
            break
        case 3: /// 给我评分
            if let url = NSURL(string: "https://itunes.apple.com/it/app/gank-da-zao-ji-zhi-degank.io/id1129157059?mt=8") {
                UIApplication.sharedApplication().openURL(url)
            }
            break
        case 4: /// 邮件反馈
            if let emailUrl = NSURL(string: "mailTo://qiuncheng@gmail.com") {
                UIApplication.sharedApplication().openURL(emailUrl)
            }
            break
        case 5: /// 版本
            let alertVC = UIAlertController(title: "", message: "当前版本为Version \(GKApp.appVersion!) (\(GKApp.appBuildVersion!))", preferredStyle: .Alert)
            let sureAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (action) in
            })
            alertVC.addAction(sureAction)
            self.presentViewController(alertVC, animated: true, completion: {
            })

            break
        case 6: /// 关于
            
            break
        default:
            break
        }
    }
}
