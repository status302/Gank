//
//  UIBarButtonItem+QC.swift
//  Gank
//
//  Created by 程庆春 on 16/5/31.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(image:UIImage?, highlightedImage:UIImage?,target: AnyObject?, action: Selector) {

        let button = UIButton(type: .Custom)
        button.setImage(image, forState: .Normal)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.sizeToFit()
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)

        
        self.init(customView: button)
    }
}
