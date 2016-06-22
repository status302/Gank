//
//  SortCell.swift
//  Gank
//
//  Created by 程庆春 on 16/6/18.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import SnapKit

class SortCell: UITableViewCell {
    var result: Result! {
        didSet {
            descLabel.text = result.desc
//            timeLabel.text = result.publishedString
            timeLabel.text = result.dateToString(result.publishedAt)

            fromLabel.text = result.who
        }
    }

    // UIs
    var iconImageView: UIImageView!
    var descLabel: UILabel!
    var timeLabel: UILabel!
    var fromLabel: UILabel!
    var lineView: UIView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {

        iconImageView = UIImageView(frame: CGRect.zero)
        iconImageView.image = UIImage(named: "unSelect")

        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(10)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }

        descLabel = UILabel(frame: CGRect.zero)
        descLabel.font = UIFont.systemFontOfSize(14)
        descLabel.textColor = UIColor.blackColor()
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()

        addSubview(descLabel)

        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.left.equalTo(iconImageView.snp.right).offset(10)
        }


        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.font = UIFont.systemFontOfSize(10)
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.numberOfLines = 0
        timeLabel.sizeToFit()

        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.leading.equalTo(descLabel.snp.leading)
        }

        fromLabel = UILabel(frame: CGRect.zero)
        fromLabel.font = timeLabel.font
        fromLabel.textColor = timeLabel.textColor
        fromLabel.numberOfLines = 0
        fromLabel.sizeToFit()

        addSubview(fromLabel)
        fromLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(10)
            make.top.equalTo(timeLabel.snp.top)
        }

        lineView = UIView(frame: CGRect.zero)
        lineView.backgroundColor = UIColor.grayColor()
        addSubview(lineView)

        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(8)
            make.right.equalTo(self.snp.right).offset(-8)
            make.height.equalTo(0.5)
            make.bottom.equalTo(self.snp.bottom)
        }


    }

    override func setSelected(selected: Bool, animated: Bool) {
        if selected {
            iconImageView.image = UIImage(named: "selected")
        } else {
            iconImageView.image = UIImage(named: "unSelect")
        }
        iconImageView.setNeedsDisplay()

        super.setSelected(selected, animated: animated)
    }
}
