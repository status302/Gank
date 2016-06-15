//
//  DetailViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/11.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Alamofire


 /**
    1. 添加下拉放大的背景
    2. 添加类qq分组的insert和delete
    3. 跳转到webView上
    4. 添加分享功能
 
 */

class DetailViewController: UIViewController {

    // MARK: - Properties
    var dateString: String! {
        didSet {
            urlString = "http://gank.io/api/day/" + dateString
        }
    }
    lazy var results = [Result]()
    var urlString: String! {
        didSet {
            // 开始网络请求
            Alamofire.request(.GET, urlString, parameters: nil, encoding: .URL, headers: nil).responseJSON { (response) in
                guard let json = response.result.value else {
                    print("网络请求发生了错误")
                    return
                }

//                print(json as! NSDictionary)

                let root = EverydayRootClass(fromDictionary: json as! NSDictionary)
                for catefory in root.categories {
                    print(root.results[catefory])
                }
            }
        }

    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //透明状态栏
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @IBAction func dismiss(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
