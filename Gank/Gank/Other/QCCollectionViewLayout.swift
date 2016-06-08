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

        attrs.removeAll()
        guard let itemCount = collectionView?.numberOfItemsInSection(0) else {
            return
        }
        for index in 0 ..< itemCount {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            let attr = self.layoutAttributesForItemAtIndexPath(indexPath)
            attrs.append(attr!)
        }

    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return self.attrs
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        let attr = super.layoutAttributesForItemAtIndexPath(indexPath)

        if indexPath.item != 0{
            var center = attr!.center
            center.x += CGFloat(60 * indexPath.item)
            attr!.center = center
        }

        return attr
    }

    override func collectionViewContentSize() -> CGSize {
        guard let itemCount = collectionView?.numberOfItemsInSection(0) else {
            return CGSizeMake(1000, 0)
        }

        return CGSizeMake(CGFloat(itemCount) * Constants.Screen_width, 0)
    }
    lazy var attrs = [UICollectionViewLayoutAttributes]()
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
