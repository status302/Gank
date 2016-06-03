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
        minimumLineSpacing = 20.0
        // 表示水平方向cell与cell之间的距离
        minimumInteritemSpacing = 20.0

        sectionInset = UIEdgeInsetsMake(0, 40.0, 40.0, 40.0)
        // 规定只能水平方向移动
        scrollDirection = .Horizontal

        // setup attrs


    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }


    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        print("\(proposedContentOffset.y)")
        return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
    }
}

class QCCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        self.backgroundColor = UIColor.whiteColor()
        /**
         *  从nib中加载cell
         */
        registerNib(UINib(nibName: "QCEverydayGankCell", bundle: nil), forCellWithReuseIdentifier: Constants.everydayGankCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
