//
//  WelfareCollectionViewCell.swift
//  Gank
//
//  Created by 程庆春 on 16/5/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class WelfareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var meiziImageView: UIImageView!




    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - lazy
    lazy var welfareViewCell: WelfareCollectionViewCell = {
        let welfareViewCell = NSBundle.mainBundle().loadNibNamed("WelfareCollectionViewCell", owner: nil, options: nil).first as! WelfareCollectionViewCell
        return welfareViewCell
    }()
}
