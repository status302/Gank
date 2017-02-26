//
//  HomeTopCell.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit
import Then

class HomeTopCell: UITableViewCell, ViewIdentifierReuseable {
    var topScrollView: TopScrollView?

    var resultJson: GankImageModel? {
        didSet {
            topScrollView?.imageJson = resultJson
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubview()

    }

    func setupSubview() {
        let _ = TopScrollView().then({
            self.topScrollView = $0
            $0.addedTo(view: self)
            $0.makeConstraints()
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
