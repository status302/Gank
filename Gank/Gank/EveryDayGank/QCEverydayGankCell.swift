//
//  QCEverydayGankCell.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class QCEverydayGankCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!


    var everydayResult: EverydayResult! {
        didSet {

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeLabel.textColor = UIColor.blackColor()
        timeLabel.font = UIFont(name: "DFPHaiBaoW12-GB", size: 14)
        sourceLabel.textColor = timeLabel.textColor
        sourceLabel.font = timeLabel.font
    }

}
