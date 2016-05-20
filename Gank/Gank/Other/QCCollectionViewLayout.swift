//
//  QCCollectionViewLayout.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class QCCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()

        itemSize = CGSizeMake(50.0, 30.0)
        // 表示竖直方向cell与cell之间的距离
        minimumLineSpacing = 5.0
        // 表示水平方向cell与cell之间的距离
        minimumInteritemSpacing = 20.0

        sectionInset = UIEdgeInsetsZero

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QCCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        self.backgroundColor = UIColor.whiteColor()
        registerClass(QCEverydayGankCell.self, forCellWithReuseIdentifier: Constants.everydayGankCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
