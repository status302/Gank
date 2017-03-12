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
import SDWebImage

class HomeResultCell: UITableViewCell, ViewIdentifierReuseable {
    
    var model: GankResult? {
        didSet {
            if let images = model?.images,
                let imageUrl = images.first,
                let url = URL(string: imageUrl + "?imageView2/1/w/66/h/44") {
                descImageView?.sd_setImage(with: url)
            }
            
            if let desc = model?.desc {
                descLabel?.text = desc
            }
            
            if let who = model?.who {
                whoLabel?.text = who
            }
            
            if let time = model?.publishedAt {
                timeLabel?.text = time
            }
        }
    }
    
    private weak var descImageView: UIImageView?
    private weak var descLabel: UILabel?
    private weak var whoLabel: UILabel?
    private weak var timeLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        let imageView = UIImageView().then({ /// 80 x 80
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = UIColor.init(hex: 0x232329)
        })
        self.descImageView = imageView
        addSubview(imageView)
        
        let descLabel = UILabel().then({
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor.darkGray
            $0.textAlignment = .left
        })
        self.descLabel = descLabel
        addSubview(descLabel)
        
        let nameLabel = UILabel().then({
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.sizeToFit()
            $0.textColor = UIColor.gray
            $0.textAlignment = .left
        })
        addSubview(nameLabel)
        self.whoLabel = nameLabel
        
        let timeLabel = UILabel().then({
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.sizeToFit()
            $0.textColor = UIColor.gray
            $0.textAlignment = .left
        })
        addSubview(timeLabel)
        self.timeLabel = timeLabel
        
        makeContraints()
    }
    
    private func makeContraints() {
        descImageView?.snp.makeConstraints({
            $0.top.equalTo(self.snp.top).offset(8)
            $0.left.equalTo(self.snp.left).offset(8)
            $0.width.equalTo(66)
            $0.height.equalTo(44)
        })
        
        descLabel?.snp.makeConstraints({
            guard let descImageView = descImageView else { return }
            $0.top.equalTo(descImageView.snp.top).offset(5)
            $0.left.equalTo(descImageView.snp.right).offset(10)
            $0.right.equalTo(self.snp.right).offset(10)
        })
        
        whoLabel?.snp.makeConstraints({
            guard let imageView = descImageView else { return }
            $0.left.equalTo(imageView.snp.right).offset(10)
            $0.bottom.equalTo(imageView.snp.bottom)
        })
        
        timeLabel?.snp.makeConstraints({
            guard let whoLabel = whoLabel else { return }
            $0.left.equalTo(whoLabel.snp.right).offset(10)
            $0.bottom.equalTo(whoLabel.snp.bottom)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
