//
//  TabbarView.swift
//  Gank
//
//  Created by yolo on 2017/1/22.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit
import DynamicColor

protocol TabbarViewDelegate: class {
    func tabbarView(tabbarView: TabbarView, didSeleted item: GankTabbarItem, with index: Int)
}

typealias GankTabbarItem = UIButton

class TabbarView: UIView {
    
    var items: [GankTabbarItem]?
    
    weak var delegate: TabbarViewDelegate?

    convenience init() {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white.darkened()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    func setItems() {
        
    }
    
    func makeContraints() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
