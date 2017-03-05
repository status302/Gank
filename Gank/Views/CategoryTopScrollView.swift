//
//  CategoryTopScrollView.swift
//  Gank
//
//  Created by 程庆春 on 2017/3/2.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit

protocol CategoryTopScrollViewDatasource {
    
}

class CategoryTopScrollView: UIControl {
    var datas: [String] = ["所有", "iOS", "前端", "Android", "扩展资源", "福利", "休息视频"]
    private(set) var eachWidth = [CGFloat]()
    private var labels = [UILabel]()
    private weak var scrollView: UIScrollView?
    
    private var selectedLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let scrollView = UIScrollView()
            .then({
                $0.showsVerticalScrollIndicator = false
                $0.showsHorizontalScrollIndicator = false
            })
        
        self.scrollView = scrollView
        addSubview(scrollView)
        
        datas.forEach({ [weak self] element in
            let font = UIFont.boldSystemFont(ofSize: 22)
            self?.eachWidth.append((element.boundsWidth(font: font, height: 44.0) + 30))
            let label = UILabel().then({
                $0.text = element
                $0.font = UIFont.boldSystemFont(ofSize: 22)
                $0.textColor = UIColor.darkGray
                $0.textAlignment = .center
            })
            self?.labels.append(label)
            self?.scrollView?.addSubview(label)
        })
        
        self.backgroundColor = UIColor.white
        makeContraints()
        
        selectedLabel = labels[0]
    }
    
    func makeContraints() {
        scrollView?.snp.makeConstraints({ [weak self] in
            guard let strongSelf = self else { return }
            $0.edges.equalTo(strongSelf.snp.edges)
                .inset(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        })
        
        for (index, label) in labels.enumerated() {
            let currentWidth = eachWidth[index]
            if index == 0 {
                label.snp.makeConstraints({ [weak self] in
                    guard let strongSelf = self else { return }
                    $0.left.equalTo(strongSelf.scrollView!.snp.left)
                    $0.top.equalTo(strongSelf.scrollView!.snp.top)
                    $0.bottom.equalTo(strongSelf.scrollView!.snp.bottom)
                    $0.width.equalTo(currentWidth)
                })
            }
            else if index == (labels.count - 1) {
                let lastLabel = labels[index - 1]
                label.snp.makeConstraints({ [weak self] in
                    guard let strongSelf = self else { return }
                    $0.left.equalTo(lastLabel.snp.right)
                    $0.top.equalTo(lastLabel.snp.top)
                    $0.bottom.equalTo(lastLabel.snp.bottom)
                    $0.width.equalTo(currentWidth)
                    $0.right.equalTo(strongSelf.scrollView!.snp.right)
                })
            }
            else {
                let lastLabel = labels[index - 1]
                label.snp.makeConstraints({
                    $0.left.equalTo(lastLabel.snp.right)
                    $0.top.equalTo(lastLabel.snp.top)
                    $0.bottom.equalTo(lastLabel.snp.bottom)
                    $0.width.equalTo(currentWidth)
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
