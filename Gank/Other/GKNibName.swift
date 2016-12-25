//
//  GKNibName.swift
//  Gank
//
//  Created by 程庆春 on 16/8/30.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

protocol NibName {
}


extension NibName {
    static var nibName: String  {
        return String(self)
    }

    static var reuseIdentifier: String {
        return String(self)
    }
}
extension UIView: NibName { }
