//
//  QCActionView.swift
//  CustomActionView
//
//  Created by 程庆春 on 16/6/12.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

/**
 *  1. 创建tableView， 并添加到UIView中
 *  2. 创建cell, 两种不同的cell
 *  3. 显示和隐藏
 *  4. 添加事件处理
 *  5. 完善其显示
 */

import UIKit

class QCActionView: UIView {

    var items = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    typealias CompletedHandler = (index:Int)-> Void

    override func layoutSubviews() {
        super.layoutSubviews()

        // 在这里处理布局问题

        let width = UIScreen.mainScreen().bounds.size.width
        let height = Constants.tableViewCellHeight * 3 + 5.0
        let x = CGFloat(0)
        let y = UIScreen.mainScreen().bounds.size.height - height
        tableView.frame = CGRectMake(x, y, width, height)
    }



    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = UIApplication.sharedApplication().keyWindow!.bounds

        // 添加hideAction
        let gesView = UIView(frame: self.bounds)
        gesView.backgroundColor = UIColor.clearColor()
        gesView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSelf)))

        addSubview(gesView)

        backgroundColor = UIColor(white: 0, alpha: 0.4)

        addSubview(tableView)

    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private functions 处理待点击空白处后将view隐藏
    func hideSelf() {

        UIView.animateWithDuration(0.2, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.tableView.frame.origin.y = UIScreen.mainScreen().bounds.height
            }) { (finished) in
                self.hidden = true
                self.removeFromSuperview()
        }
    }

    // MARK: - lazy
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .Plain)

        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.lightGrayColor()
        tableView.scrollEnabled = false
        tableView.sizeToFit()

        tableView.registerClass(ActionViewSelectedCell.self, forCellReuseIdentifier: Constants.cellID)

        return tableView

    }()
    var completedHandler: CompletedHandler?

    // MARK: - Constants
    struct Constants {
        static let cellID = "cellID"
        static let tableViewCellHeight:CGFloat = 56
    }
//    func showItemBlocks(itemBlock: ItemBlock, selectedBlock: SelectedBlock) {
//
//    }

    func showActionView(completedHandler: CompletedHandler) {
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self)

        self.tableView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width, Constants.tableViewCellHeight * 3 + 5.0)

        self.hidden = false
        UIView.animateWithDuration(0.2, animations: {
            self.tableView.frame.origin.y = UIScreen.mainScreen().bounds.height - self.tableView.frame.size.height
            }) { (finished) in
                // 回调处理
                self.completedHandler = completedHandler
        }
    }

}

extension QCActionView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return items.count
        } else {
            return 1
        }

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellID) as! ActionViewSelectedCell
        if indexPath.section == 0 {
            cell.titleLabel.text = items[indexPath.row]
//            if indexPath.item == 0 {
//                cell.titleLabel.text = "分享"
//            } else {
//                cell.titleLabel.text = "保存"
//            }
        }else {
            cell.textLabel?.textColor = UIColor.redColor()
            cell.titleLabel.text = "取消"
        }
        return cell
    }
    /**
     *  设置cell的高度为56
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.tableViewCellHeight
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5.0
        } else {
            return  0.0
        }
    }
}

extension QCActionView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            hideSelf()
        } else {
            completedHandler!(index: indexPath.row)
            hideSelf()
        }
    }
}

class ActionViewSelectedCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(titleLabel)
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = CGRectMake(0, 0, self.bounds.width, self.bounds.height)
        lineView.frame = CGRectMake(0, self.bounds.height - 0.5, self.bounds.width, 0.5)

    }

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        return lineView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(16)

        return label
    }()

}