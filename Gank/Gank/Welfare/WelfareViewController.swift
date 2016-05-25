//
//  WelfareViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/23.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Kingfisher

class WelfareViewController: UIViewController {

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)

        AlamofireManager.sharedInstance.fetchDataForWelfare { (rootClass) in
            guard let root = rootClass else {
                return
            }

            self.results = root.results
            self.collectionView.reloadData()
        }

    }

    // MARK: - lazy

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = Constants.Screen_width*0.5 - 2.0
        layout.itemSize = CGSizeMake( width, width)
        layout.minimumLineSpacing = 2.0
        layout.minimumInteritemSpacing = 2.0
        

        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)

        collectionView.backgroundColor = UIColor.whiteColor()

        collectionView.contentInset = UIEdgeInsetsZero

        collectionView.dataSource = self


//        collectionView.registerClass(WelfareCollectionViewCell.self, forCellWithReuseIdentifier: Constants.welfareCellID)
        collectionView.registerNib(UINib.init(nibName: "WelfareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.welfareCellID)

        return collectionView
    }()

    lazy var results = [Result]()

}
// MARK: - UICollectionViewDataSource
extension WelfareViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.welfareCellID, forIndexPath: indexPath) as! WelfareCollectionViewCell

        cell.result = results[indexPath.row]

        return cell
    }
}
