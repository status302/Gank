//
//  TopScrollView.swift
//  Gank
//
//  Created by yolo on 2017/1/19.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import Then

class TopScrollView: UIView {
    
    var imageJson: GankJson? {
        didSet {
            
        }
    }
    
    var imageViews = [UIImageView]()
    var scrollView: UIScrollView!
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let scrollView = UIScrollView().then({
            $0.alwaysBounceHorizontal = false
            $0.alwaysBounceVertical = false
            $0.showsHorizontalScrollIndicator = false
            $0.delegate = self
            $0.isPagingEnabled = true
        })
        
        addSubview(scrollView)
        self.scrollView = scrollView
        
        scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        for i in 0...6 {
            let imageView = UIImageView().then({
                $0.backgroundColor = UIColor.gk_random
                let label = UILabel().then({
                    $0.text = "第\(i)张"
                    $0.sizeToFit()
                })
                $0.addSubview(label)
            })
            imageView.backgroundColor = UIColor.gk_random
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        }
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func makeConstraints() {
        guard let superView = superview else { return }
        
        self.snp.makeConstraints({
            $0.left.equalTo(superView.snp.left)
            $0.top.equalTo(superView.snp.top)
            $0.right.equalTo(superView.snp.right)
            $0.height.equalTo(360.0)
        })
        
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(self)
        })
    
        for (i, imageView) in imageViews.enumerated() {
            imageView.snp.makeConstraints({
                $0.top.equalTo(self.snp.top)
                $0.bottom.equalTo(self.snp.bottom)
                $0.width.equalTo(self.snp.width)
            })
            
            if i == 0 {
                imageView.snp.makeConstraints({
                    $0.left.equalTo(scrollView.snp.left)
                })
            } else if i == 6 {
                imageView.snp.makeConstraints({
                    let lastImageView = imageViews[i-1]
                    $0.left.equalTo(lastImageView.snp.right)
                    $0.right.equalTo(scrollView.snp.right)
                })
            } else {
                let lastImageView = imageViews[i - 1]
                imageView.snp.makeConstraints({
                    $0.left.equalTo(lastImageView.snp.right)
                })
            }
        }
    }
    
    func addedTo(view: UIView) {
        if view.subviews.contains(self) {
            return
        }
        view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopScrollView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            scrollView.setContentOffset(CGPoint(x: self.frame.width * 5, y: 0), animated: false)
        }
        if scrollView.contentOffset.x == self.frame.width * 6 {
            scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        }
    }
}
