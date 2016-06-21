//
//  SortViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/27.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var headScrollView: UIScrollView!

    // MARK: - lazy Variales
    private lazy var titles: [String] = {
        let titles = ["Android","iOS","休息视频","拓展资源","前端","福利", "随机"]
        return titles
    }()


    /// contentScrollView
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.delegate = self

        scrollView.contentSize = CGSizeMake(Common.Screen_width * CGFloat(self.childViewControllers.count), 0)

        scrollView.frame = self.view.bounds

        let top = self.headScrollView.y
        scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)

        scrollView.pagingEnabled = true

        scrollView.backgroundColor = UIColor.clearColor()

        return scrollView
    }()
    /**
     添加子控制器到该VC中
     */
    func setupChildVCs() {
        /// AndroidVC
        let androidVC = QCTopicViewController()
        androidVC.type = URLType.android
        addChildViewController(androidVC)
        /// iOSVC
        let iosVC = QCTopicViewController()
        iosVC.type = URLType.iOS
        addChildViewController(iosVC)
        /// 休息视频
        let sleepVC = QCTopicViewController()
        sleepVC.type = URLType.sleep
        addChildViewController(sleepVC)
        /// resourse VC
        let resourseVC = QCTopicViewController()
        resourseVC.type = URLType.resourse
        addChildViewController(resourseVC)

        let frontEnd = QCTopicViewController()
        frontEnd.type = URLType.front_end
        addChildViewController(frontEnd)

        let welfareVC = QCTopicViewController()
        welfareVC.type = URLType.welfare
        addChildViewController(welfareVC)

        let randomVC = QCTopicViewController()
        randomVC.type = URLType.all
        addChildViewController(randomVC)

    }
    // MARK: - Properties
    var disabledButton: UIButton!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Common.navigationBarBackgroundColor
        self.automaticallyAdjustsScrollViewInsets = false

        setupHeadView()

        self.setupNav()

        /**
         处理子VC相关的
         */

        self.setupChildVCs()

        view.insertSubview(scrollView, belowSubview: headScrollView)

        self.scrollViewDidEndScrollingAnimation(scrollView)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /**
         *  隐藏状态栏
         */
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        /**
         headScrollView background
         */
        headScrollView.backgroundColor = UIColor.orangeColor()
    }
    //
    // MARK: - private functions

    private func setupNav() {

        let titleLabel = UILabel()
        titleLabel.text = "干货分类"
        titleLabel.font = UIFont(name: "DFPHaiBaoW12-GB", size: 18)
        titleLabel.sizeToFit()
        titleLabel.tintColor = UIColor.blackColor()
        navigationItem.titleView = titleLabel
    }
    /**
     根据stirng来计算UIButton的size
     */
    func buttonSize(str: String) -> CGSize? {
        return (str as NSString).boundingRectWithSize(headScrollView.size, options: NSStringDrawingOptions.init(rawValue: 0), attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18)], context: nil).size
    }

    private func setupHeadView() {

        self.automaticallyAdjustsScrollViewInsets = false

        var widths = [CGFloat]()
        var xs = [CGFloat]()
        var headWidth: CGFloat = 0.0
        for title in titles {
            let size = buttonSize(title)
            headWidth += (size!.width + 20)
            xs.append(headWidth)
            widths.append(size!.width)
        }
        xs.insert(5, atIndex: 0)

        headScrollView.contentSize = CGSizeMake(headWidth, 0)

        for (index, title) in titles.enumerate() {
            let button = UIButton(type: .Custom)
            button.setTitle(title, forState: .Normal)
            button.setTitle(title, forState: .Disabled)

            button.titleLabel?.textAlignment = .Center

            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitleColor(UIColor.redColor(), forState: .Disabled)
            button.titleLabel?.font = UIFont.systemFontOfSize(18)

            button.tag = 1000*index
            button.frame = CGRectMake(xs[index], 0, widths[index] + 20, headScrollView.height)
            button.addTarget(self, action: #selector(SortViewController.didClickHeadButton(_:)), forControlEvents: .TouchUpInside)

            headScrollView.addSubview(button)
            if index == 0 {
                //                didClickHeadButton(button)
                button.enabled = false
                disabledButton = button
            }
        }

    }
    @objc private func didClickHeadButton(sender: UIButton) {
        disabledButton.enabled = true
        sender.enabled = false
        disabledButton = sender

        // 在这里处理应该显示哪一个view

        var offset = scrollView.contentOffset
        offset.x = CGFloat(sender.tag / 1000) * self.scrollView.width

        scrollView.setContentOffset(offset, animated: true)

        if (sender.centerX > Common.Screen_width * 0.5) && ((headScrollView.contentSize.width - sender.centerX) > Common.Screen_width * 0.5) {
            UIView.animateWithDuration(0.2, animations: { 
                self.headScrollView.contentOffset.x = sender.centerX - Common.Screen_width * 0.5
            })
        } else {
//            UIView.animateWithDuration(0.2, animations: { 
//                self.headScrollView.contentOffset.x = 0
//            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SortViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)

        let index = Int(scrollView.contentOffset.x / scrollView.width)

        var buttons = [UIButton]()

        for button in headScrollView.subviews where button.isKindOfClass(UIControl.self) {
            buttons.append(button as! UIButton)
        }
        didClickHeadButton(buttons[index])

    }


    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.width)

        let vc = self.childViewControllers[index] as! QCTopicViewController

        vc.view.x = scrollView.contentOffset.x
        vc.view.y = self.headScrollView.height
        vc.view.height = scrollView.height
        vc.view.width = scrollView.width


        vc.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64 + 36 + 36, right: 0)
        vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset

        // 该方法可以判断vc.view 是否为scrollView的子view
        if !vc.view.isDescendantOfView(scrollView) {
            scrollView.addSubview(vc.view)
        }


    }
}
