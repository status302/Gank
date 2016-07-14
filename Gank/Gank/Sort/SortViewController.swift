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

    let headTitleFont = UIFont.font_roboto_bold(size: Common.headScrollViewButtonTitleFontSize) ?? UIFont.systemFontOfSize(Common.headScrollViewButtonTitleFontSize)

    // MARK: - lazy Variales
    private lazy var titles: [String] = {
        var titles = [String]()
        if Common.isSimulator {
            titles = ["iOS","全部", "App", "休息视频","拓展资源","前端","福利", "随机"]
        } else {
            titles = ["iOS","全部", "安卓", "App", "休息视频","拓展资源","前端","福利", "随机"]
        }
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
        /// iOSVC
        let iosVC = QCTopicViewController()
        iosVC.type = URLType.iOS
        addChildViewController(iosVC)

         /// AllVC
        let allVC = QCTopicViewController()
        allVC.type = URLType.all
        addChildViewController(allVC)

        if Common.isSimulator {
            // 是模拟器的话不做任何处理
        } else {
            /// AndroidVC
            let androidVC = QCTopicViewController()
            androidVC.type = URLType.android
            self.addChildViewController(androidVC)
        }

        /// App
        let appVC = QCTopicViewController()
        appVC.type = URLType.App
        addChildViewController(appVC)

        /// 休息视频
        let sleepVC = QCTopicViewController()
        sleepVC.type = URLType.sleep
        addChildViewController(sleepVC)

        /// resourse VC
        let resourseVC = QCTopicViewController()
        resourseVC.type = URLType.resourse
        addChildViewController(resourseVC)

        /// 前端
        let frontEnd = QCTopicViewController()
        frontEnd.type = URLType.front_end
        addChildViewController(frontEnd)

        /// 福利
        let welfareVC = QCTopicViewController()
        welfareVC.type = URLType.welfare
        addChildViewController(welfareVC)

        /// 随机
        let randomVC = QCTopicViewController()
        randomVC.type = URLType.all
        addChildViewController(randomVC)

    }
    // MARK: - Properties
    var disabledButton: UIButton!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self

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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil,action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()

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
        headScrollView.backgroundColor = Common.navigationBarBackgroundColor
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = nil
    }
    //
    // MARK: - private functions

    private func setupNav() {

        let titleLabel = UILabel()
        titleLabel.text = "干货分类"
        titleLabel.font = UIFont.font_dfphaib(size: 18)
        titleLabel.sizeToFit()
        titleLabel.tintColor = UIColor.blackColor()
        navigationItem.titleView = titleLabel
    }
    /**
     根据stirng来计算UIButton的size
     */
    func buttonSize(str: String) -> CGSize? {

        return (str as NSString).boundingRectWithSize(headScrollView.size, options: NSStringDrawingOptions.init(rawValue: 0), attributes: [NSFontAttributeName: headTitleFont], context: nil).size
    }

    private func setupHeadView() {

        self.automaticallyAdjustsScrollViewInsets = false
        headScrollView.showsHorizontalScrollIndicator = false

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
            button.titleLabel?.font = headTitleFont // UIFont.systemFontOfSize(18)

            button.tag = 1000*index
            button.frame = CGRectMake(xs[index], 0, widths[index] + 20, headScrollView.height)
            button.addTarget(self, action: #selector(SortViewController.didClickHeadButton(_:)), forControlEvents: .TouchUpInside)

            headScrollView.addSubview(button)
            if index == 0 {
                //                didClickHeadButton(button)
                button.enabled = false
                UIView.animateWithDuration(0.1, animations: { 
                    button.transform = CGAffineTransformMakeScale(Common.headScrollViewButtonScaleRate, Common.headScrollViewButtonScaleRate)
                })
                disabledButton = button

            }
        }

    }
    @objc private func didClickHeadButton(sender: UIButton) {
        disabledButton.enabled = true
        sender.enabled = false
        UIView.animateWithDuration(0.1) { 
            self.disabledButton.transform = CGAffineTransformIdentity
            sender.transform = CGAffineTransformMakeScale(Common.headScrollViewButtonScaleRate, Common.headScrollViewButtonScaleRate)
        }
        disabledButton = sender

        // 在这里处理应该显示哪一个view

        var offset = scrollView.contentOffset
        offset.x = CGFloat(sender.tag / 1000) * self.scrollView.width

        scrollView.setContentOffset(offset, animated: true)
        /**
         *  滚动每一个title与其vc对齐
         */
        if (sender.centerX > Common.Screen_width * 0.5) && ((headScrollView.contentSize.width - sender.centerX) > Common.Screen_width * 0.5) {
            UIView.animateWithDuration(0.2, animations: { 
                self.headScrollView.contentOffset.x = sender.centerX - Common.Screen_width * 0.5
            })
        } else if sender.centerX < Common.Screen_width * 0.5{
            UIView.animateWithDuration(0.2, animations: {
                self.headScrollView.contentOffset.x = 0
            })
        } else if (headScrollView.contentSize.width - sender.centerX) < Common.Screen_width * 0.5{
            UIView.animateWithDuration(0.2, animations: {
                self.headScrollView.contentOffset.x = self.headScrollView.contentSize.width - Common.Screen_width
            })
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

extension SortViewController: UITabBarControllerDelegate {
    
}
