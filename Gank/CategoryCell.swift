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
//    var everydayCategory: String? {
//        didSet {
//        }
//    }
    var selectedImageView: UIImageView?

    var titleLabel: UILabel?
    var lineView: UIView!
    var timeLabel: UILabel! // 显示时间的label
    var fromLabel: UILabel!

    /**
     设置数据源
     */
    var desHeight: CGFloat!
    var timeHeight: CGFloat!
    var cellHeight: CGFloat!

    var everydayResult: EverydayResult!  {
        didSet {
            self.titleLabel?.text = everydayResult.desc
            self.timeLabel.text = everydayResult.publishedTime
            self.fromLabel.text = everydayResult.who
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        isSelected = false
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {

        selectedImageView = UIImageView(frame: CGRect.zero)
        addSubview(selectedImageView!)

        selectedImageView?.snp.makeConstraints( closure: { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(contentView.snp.centerY)
            make.size.equalTo(CGSize(width: 10, height: 10))
        })
        selectedImageView?.image = UIImage(named: "unSelect")

        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel?.font = UIFont.systemFontOfSize(12)
        titleLabel?.textColor = UIColor.blackColor()
        titleLabel?.numberOfLines = 0
        titleLabel?.minimumScaleFactor = 0.5
        titleLabel?.adjustsFontSizeToFitWidth = true
        
        titleLabel?.sizeToFit()
        addSubview(titleLabel!)

        titleLabel!.snp.makeConstraints { (make) in
            make.left.equalTo((selectedImageView?.snp.right)!).offset(10)
            make.top.equalTo(self.snp.top).offset(5)
            make.right.equalTo(self.snp.right).offset(-10)
//            make.height.equalTo(desHeight)
        }

        lineView = UIView(frame: CGRect.zero)
        lineView.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(8)
            make.right.equalTo(self.snp.right).offset(-8)
            make.height.equalTo(0.5)
            make.bottom.equalTo(self.snp.bottom)
        }

        timeLabel = UILabel(frame: CGRect.zero)
        timeLabel.font = UIFont.systemFontOfSize(10)
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.sizeToFit()
        self.addSubview(timeLabel)

        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel!.snp.leading)
            make.top.equalTo(titleLabel!.snp.bottom).offset(5)
        }

        fromLabel = UILabel(frame: CGRect.zero)
        fromLabel.font = timeLabel.font
        fromLabel.textColor = timeLabel.textColor
        fromLabel.sizeToFit()
        self.addSubview(fromLabel)

        fromLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.top)
            make.left.equalTo(timeLabel.snp.right).offset(5)
        }
    }
    /**
      设置其选中状态
     - parameter selected: 是否被选中
     - parameter animated: 选中动画
     */
    override func setSelected(selected: Bool, animated: Bool) {

        if selected {
            selectedImageView?.image = UIImage(named: "selected")
        } else {
            selectedImageView?.image = UIImage(named: "unSelect")
        }
        selectedImageView!.setNeedsDisplay()
        super.setSelected(selected, animated: animated)

    }
}
