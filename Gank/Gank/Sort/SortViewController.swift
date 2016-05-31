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
        let titles = ["Android","iOS","休息视频","拓展资源","前端","福利"]
        return titles
    }()
    // MARK: - Properties
    var disabledButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.


        setupHeadView()
    }

    // MARK: - private functions

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
            print("\(size)")
        }
        xs.insert(5, atIndex: 0)

        headScrollView.contentSize = CGSizeMake(headWidth, 0)

        for (index, title) in titles.enumerate() {
            let button = UIButton(type: .Custom)
            button.setTitle(title, forState: .Normal)
            button.setTitle(title, forState: .Disabled)

//            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
            button.titleLabel?.textAlignment = .Center

            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitleColor(UIColor.redColor(), forState: .Disabled)
            button.titleLabel?.font = UIFont.systemFontOfSize(18)

            button.frame = CGRectMake(xs[index], 0, widths[index] + 20, headScrollView.height)
            button.addTarget(self, action: #selector(SortViewController.didClickHeadButton(_:)), forControlEvents: .TouchUpInside)

            headScrollView.addSubview(button)
            if index == 0 {
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SortViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        print("offsetX is : \(offsetX)")

        // 待处理顶部view的滚动问题

    }
}
