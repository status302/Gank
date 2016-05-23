//
//  WelfareViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/23.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class WelfareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)

    }

    lazy var collectionView: UICollectionView = {
        let layout = QCCollectionLayout()

        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)

        collectionView.dataSource = self

        collectionView.backgroundColor = UIColor.redColor()

        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.welfareCellID)

        return collectionView
    }()

}

extension WelfareViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.welfareCellID, forIndexPath: indexPath)

        return cell
    }
}
