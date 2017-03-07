//
//  HomeResultCell.swift
//  Gank
//
//  Created by yolo on 2017/3/6.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit
import Then

class HomeResultCell: UITableViewCell, ViewIdentifierReuseable {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
