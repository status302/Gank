//
//  CoverFlowLayout.swift
//  CoverFlowLayout
//
//  Created by Broccoli on 15/11/26.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class CoverFlowLayout: UICollectionViewFlowLayout {
    let kDistanceToProjectionPlane: CGFloat = 500.0
    
    var maxCoverDegree: CGFloat = 30.0
    var coverDensity: CGFloat = 0.25

    /**
     告诉layout对象cell的bounds需要更新了。

     - parameter newBounds: 新的bounds

     - returns: true：表示可以更新了；false：不可以更新，往往会出现未知的错误
     */
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    /**
     布局所有cell的属性

     - parameter rect: 包含目标view的rect（目标view也就是cell所在的view）

     - returns: 装有所有cell属性值的数组
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let indexPaths = indexPathsOfItemsInRect(rect)
        
        var resultingAttributes = [UICollectionViewLayoutAttributes]()
        
        for indexPath in indexPaths {
            let attributes = layoutAttributesForItemAtIndexPath(indexPath)!
            resultingAttributes.append(attributes)
        }
        return resultingAttributes
    }

    /**
     给每一个cell布局

     - parameter indexPath: cell所在的indexPath

     - returns: 返回该cell的布局属性
     */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.size = itemSize
        attributes.center = CGPoint(x: collectionView!.bounds.size.width * CGFloat(indexPath.row) + collectionView!.bounds.size.width, y: collectionView!.bounds.size.height / 2)
        
        interpolateAttributes(attributes, forOffset: collectionView!.contentOffset.x)
        return attributes
    }
    /**
     用来设置collectionView的contentSize

     - returns: 返回结果为collectionView ContentSize
     */
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: collectionView!.bounds.width * CGFloat(collectionView!.numberOfItemsInSection(0)), height: collectionView!.bounds.height)
    }
}


// MARK: - private method
private extension CoverFlowLayout {
    /**
     <#Description#>

     - parameter rect: <#rect description#>

     - returns:
     */
    func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        // 如果该section中没有包含item，则直接返回
        if collectionView!.numberOfItemsInSection(0) == 0 {
            return [NSIndexPath]()
        }
        var minRow: Int = max(Int(rect.origin.x / collectionView!.bounds.width), 0)
        var maxRow: Int = Int(CGRectGetMaxX(rect) / collectionView!.bounds.width)
        
        let candidateMinRow = max(minRow - 1, 0)
        if maxXForRow(candidateMinRow) >= rect.origin.x {
            minRow = candidateMinRow
        }
        
        let candidateMaxRow = min(maxRow + 1, collectionView!.numberOfItemsInSection(0) - 1)
        if minXForRow(candidateMaxRow) <= CGRectGetMaxX(rect) {
            maxRow = candidateMaxRow
        }
        
        var resultingInexPaths = [NSIndexPath]()
        
        for i in Int(minRow) ..< Int(maxRow) + 1 {
            resultingInexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        return resultingInexPaths
    }

    func minXForRow(row: Int) -> CGFloat {
        return itemCenterForRow(row - 1).x + (1 / 2 - coverDensity) * itemSize.width
    }
    
    func maxXForRow(row: Int) -> CGFloat {
        return itemCenterForRow(row + 1).x - (1 / 2 - coverDensity) * itemSize.width
    }
    
    func minXCenterForRow(row: Int) -> CGFloat {
        let halfWidth = itemSize.width / 2
        let maxRads = maxCoverDegree * CGFloat(M_PI) / 180
        let center = itemCenterForRow(row - 1).x
        let prevItemRightEdge = center + halfWidth
        let projectedLeftEdgeLocal = halfWidth * cos(maxRads) * kDistanceToProjectionPlane / (kDistanceToProjectionPlane + halfWidth * sin(maxRads))
        return prevItemRightEdge - coverDensity * itemSize.width + projectedLeftEdgeLocal
    }
    
    func maxXCenterForRow(row: Int) -> CGFloat {
        let halfWidth = itemSize.width / 2
        let maxRads = maxCoverDegree * CGFloat(M_PI) / 180
        let center = itemCenterForRow(row + 1).x
        let nextItemLeftEdge = center - halfWidth
        let projectedRightEdgeLocal = fabs(halfWidth * cos(maxRads) * kDistanceToProjectionPlane / (-halfWidth * sin(maxRads) - kDistanceToProjectionPlane))
        return nextItemLeftEdge + coverDensity * itemSize.width - projectedRightEdgeLocal
    }

    /**
     获取在center处的item的坐标。

     - parameter row: item所在的row

     - returns: 该item的center的坐标
     */
    func itemCenterForRow(row: Int) -> CGPoint {
        let collectionViewSize = collectionView!.bounds.size
        return CGPoint(x: CGFloat(row) * collectionViewSize.width + collectionViewSize.width / 2, y: collectionViewSize.height / 2)
    }
    
    func interpolateAttributes(attributes: UICollectionViewLayoutAttributes, forOffset offset: CGFloat) {
        let attributesPath = attributes.indexPath
        
        let minInterval = CGFloat(attributesPath.row - 1) * collectionView!.bounds.width
        let maxInterval = CGFloat(attributesPath.row + 1) * collectionView!.bounds.width
        
        let minX = minXCenterForRow(attributesPath.row)
        let maxX = maxXCenterForRow(attributesPath.row)
        
        let interpolatedX = min(max(minX + (((maxX - minX) / (maxInterval - minInterval)) * (offset - minInterval)), minX), maxX)
        attributes.center = CGPoint(x: interpolatedX, y: attributes.center.y)
        
        let angle = -maxCoverDegree + (interpolatedX - minX) * 2 * maxCoverDegree / (maxX - minX)
        var transform = CATransform3DIdentity
        
        transform.m34 = -1.0 / kDistanceToProjectionPlane
        transform = CATransform3DRotate(transform, angle * CGFloat(M_PI) / 180, 0, 1, 0)
        attributes.transform3D = transform
        attributes.zIndex = NSIntegerMax - attributesPath.row
    }
}
