//
//  CategoryCell.swift
//  Gank
//
//  Created by 程庆春 on 16/6/16.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import SnapKit

class CategoryCell: UITableViewCell {


    var isSelected: Bool?
    var category: EverydayCategory? {
        didSet {
            self.textLabel?.text = category?.category
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
