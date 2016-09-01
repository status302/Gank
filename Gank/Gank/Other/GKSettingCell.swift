//
//  GKSettingCell.swift
//  Gank
//
//  Created by 程庆春 on 16/8/30.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class GKSettingCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
