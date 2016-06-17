//
//  DetailCell.swift
//  Gank
//
//  Created by 程庆春 on 16/6/16.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class DetailCell: UITableViewCell {

    var iconImageView: UIImageView?
    var descForDetailLabel: UILabel?
    var isShowing: Bool?

    var result: EverydayResult? {
        didSet {
            self.textLabel?.text = result?.desc
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    func setupUI() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
