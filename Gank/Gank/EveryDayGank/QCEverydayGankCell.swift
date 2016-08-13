//
//  QCEverydayGankCell.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class QCEverydayGankCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!

    @IBOutlet weak var labelsstackView: UIStackView!
//    var result: Result! {
    var result: SortResult! {
        didSet {
            timeLabel.text = SortResult.dateToString(result.publishedAt!)
            sourceLabel.text = result.who
            
            let url = NSURL(string: result.url!)!
            imageView.kf_setImageWithURL(url)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        for view in self.subviews {
            if view.isDescendantOfView(UIStackView()) {
                view.removeFromSuperview()
            }
            self.insertSubview(labelsstackView, aboveSubview: imageView)
            labelsstackView.snp.makeConstraints(closure: { (make) in
                make.left.equalTo(self.snp.left).offset(10)
                make.bottom.equalTo(self.snp.bottom).offset(-10)
            })
        }



        timeLabel.font = UIFont.font_dfphaib(size: 12) //UIFont(name: "DFPHaiBaoW12-GB", size: 12)
        timeLabel.textColor = UIColor.whiteColor()
        sourceLabel.font = timeLabel.font
        sourceLabel.textColor = timeLabel.textColor

        imageView.contentMode = .ScaleToFill

    }
    override func layoutSubviews() {
        
    }

}
