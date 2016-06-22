//
//  QCEverydayGankCell.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Kingfisher

class QCEverydayGankCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!


    var result: Result! {
        didSet {
            let url = NSURL(string: result.url)!
            imageView.kf_setImageWithURL(url)
            timeLabel.text = result.publishedString
            sourceLabel.text = result.who
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
