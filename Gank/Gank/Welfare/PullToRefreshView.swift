//
//  PullToRefreshView.swift
//  Gank
//
//  Created by 程庆春 on 16/6/1.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class PullToRefreshView: UIView {

    @IBOutlet weak var imageOne:UIImageView!
    @IBOutlet weak var imageTwo:UIImageView!
    @IBOutlet weak var imageThree:UIImageView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        startAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)


    }
    override func awakeFromNib() {
        super.awakeFromNib()
        startAnimation()

    }
    // MARK: - lazy
    class func refreshView()->PullToRefreshView {

        let refreshView: PullToRefreshView = NSBundle.mainBundle().loadNibNamed("PullToRefreshView", owner: nil, options: nil).last as! PullToRefreshView
        return refreshView
    }

    func startAnimation() {


        imageOne.transform = CGAffineTransformMakeScale(0.2, 0.2)
        imageTwo.transform = CGAffineTransformMakeScale(0.2, 0.2)
        imageThree.transform = CGAffineTransformMakeScale(0.2, 0.2)

        UIView.animateWithDuration(0.6, delay: 0.0, options: [.Autoreverse, .Repeat], animations: {
            self.imageOne.transform = CGAffineTransformIdentity
            }, completion: nil)

        UIView.animateWithDuration(0.6, delay: 0.2, options: [.Autoreverse, .Repeat], animations: {
            self.imageTwo.transform = CGAffineTransformIdentity
            }, completion: nil)
        UIView.animateWithDuration(0.6, delay: 0.4, options: [.Autoreverse, .Repeat], animations: {
            self.imageThree.transform = CGAffineTransformIdentity
            }, completion: nil)

    }

}
