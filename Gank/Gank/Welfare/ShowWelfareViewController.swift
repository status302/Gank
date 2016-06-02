//
//  ShowWelfareViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/6/2.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class ShowWelfareViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var result: Result?

    override func viewDidLoad() {
        super.viewDidLoad()

        var image: UIImage?

        if let result = result  {
            let imageData = NSData(contentsOfURL: NSURL(string: result.url)!)
            image = UIImage(data: imageData!)
        }
        let width = image?.size.width
        let height = image?.size.height

        let imageViewHeight = Constants.Screen_width / width! * height!
        let imageView = UIImageView(frame: CGRectMake(0, 0, Constants.Screen_width, imageViewHeight))
        imageView.contentMode = .ScaleAspectFit
        if imageViewHeight < Constants.Screen_height {
            imageView.center.y = UIScreen.mainScreen().bounds.height * 0.5
        } else {
        }
        imageView.image = image!

        self.scrollView.contentSize = CGSizeMake(0, imageViewHeight)
        self.scrollView.addSubview(imageView)


    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)


    }
    @IBAction func didClickDismissButton(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
//        self.dismissViewControllerAnimated(true) {
//            print("已经退出----")
//        }
    }

    @IBAction func dismissVC(segue: UIStoryboardSegue) {

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
