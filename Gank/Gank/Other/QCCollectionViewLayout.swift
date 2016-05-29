//
//  QCCollectionViewLayout.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class QCCollectionViewLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        super.prepareLayout()

        itemSize = CGSizeMake(Constants.CollectionViewLayoutCellWidth, Constants.CollectionViewLayoutCellHeight)
        // 表示竖直方向cell与cell之间的距离
        minimumLineSpacing = 80.0
        // 表示水平方向cell与cell之间的距离
        minimumInteritemSpacing = 20.0

        sectionInset = UIEdgeInsetsMake(0, 40.0, 40.0, 40.0)
        // 规定只能水平方向移动
        scrollDirection = .Horizontal

        

    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }


}

class QCCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        self.backgroundColor = UIColor.whiteColor()
//        registerClass(QCEverydayGankCell.self, forCellWithReuseIdentifier: Constants.everydayGankCellID)
        registerNib(UINib(nibName: "QCEverydayGankCell", bundle: nil), forCellWithReuseIdentifier: Constants.everydayGankCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
