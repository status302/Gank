//
//  QCEveryDayGnakViewController.swift
//  Gank
//
//  Created by 程庆春 on 16/5/20.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import Alamofire

class QCEveryDayGnakViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.addSubview(self.collectionView)

        // Alamofire

        Alamofire.request(.GET, "http://gank.io/api/day/2016/05/20", parameters: nil, encoding: .URL, headers: nil).responseJSON { (response) in
            if let json = response.result.value {

            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 设置导航栏透明
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 设置导航栏为nil
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    lazy var collectionView: QCCollectionView = {
        let collectionView: QCCollectionView = QCCollectionView(frame: self.view.bounds, collectionViewLayout: QCCollectionViewLayout())

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView

    }()
    
}

extension QCEveryDayGnakViewController {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.everydayGankCellID, forIndexPath: indexPath) as UICollectionViewCell
        let labelTag = 10
        var label = cell.contentView.viewWithTag(labelTag) as? UILabel
        if label == nil {
            label = UILabel()
            label?.tag = labelTag
            cell.contentView.addSubview(label!)
        }
        label?.text = "\(indexPath.row)"
        label?.sizeToFit()

        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}

