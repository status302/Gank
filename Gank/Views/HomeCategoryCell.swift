//
//  HomeCategoryCell.swift
//  Gank
//
//  Created by 程庆春 on 2017/2/26.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class HomeCategoryCell: UITableViewCell, ViewIdentifierReuseable {

    fileprivate weak var guideLabel: UILabel?
    fileprivate weak var nameLabel: UILabel?


    var categoryName: String? {
        didSet {
            nameLabel?.text = categoryName
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupSubviews() {
        self.selectionStyle = .none
        
        let _ = UILabel().then({
            $0.font = UIFont.init(fa_fontSize: 26)
            $0.fa_text = .fa_arrow_right
            $0.textColor = UIColor.darkGray.lighter()
            $0.sizeToFit()
            addSubview($0)
            self.guideLabel = $0
        })

        let _ = UILabel().then({
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor.gray
            $0.textAlignment = .left
            $0.sizeToFit()
            addSubview($0)
            self.nameLabel = $0
        })

        makeContraints()
    }

    func makeContraints() {
        guideLabel?.snp.makeConstraints({
            $0.left.equalTo(self.snp.left).offset(10)
            $0.centerY.equalTo(self.snp.centerY)
        })

        nameLabel?.snp.makeConstraints({
            $0.left.equalTo(guideLabel!.snp.right).offset(10)
            $0.centerY.equalTo(self.snp.centerY)
        })
    }

}
