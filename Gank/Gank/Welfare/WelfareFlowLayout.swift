//
//  WelfareFlowLayout.swift
//  Gank
//
//  Created by 程庆春 on 16/5/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class WelfareFlowLayout: UICollectionViewFlowLayout {

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

}
