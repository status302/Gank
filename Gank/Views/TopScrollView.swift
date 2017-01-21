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

protocol TopScrollViewDelegate: class {
    
}

class TopScrollView: UIView {
    
    var imageJson: GankJson? {
        didSet {
            if let results = imageJson?.results {
                if results.count > (imageViews.count - 2) {
                    for (index, imageView) in imageViews.enumerated() {
                        if index == 0 {
                            if let urlStr = results[imageViews.count - 3].url {
                                if let url = URL(string: urlStr) {
                                    imageView.sd_setImage(with: url, placeholderImage: nil)
                                }
                            }
                        }
                        else if index == (imageViews.count - 1) {
                            if let urlStr = results[0].url {
                                if let url = URL(string: urlStr) {
                                    imageView.sd_setImage(with: url, placeholderImage: nil)
                                }
                            }
                        }
                        else {
                            if let urlStr = results[index - 1].url {
                                if let url = URL(string: urlStr) {
                                    imageView.sd_setImage(with: url, placeholderImage: nil)
                                }
                            }
                        }
                        activityIndicatorView?.stopAnimating()
                        pageControl?.isHidden = false
                    }
                }
            }
        }
    }
    
    private var imageViews = [UIImageView]()
    var scrollView: UIScrollView!
    private var activityIndicatorView: UIActivityIndicatorView?
    fileprivate var pageControl: UIPageControl?
    weak var delegate: TopScrollViewDelegate?
    
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
        
        for _ in 0...6 {
            let imageView = UIImageView().then({
                $0.backgroundColor = UIColor.gk_random
                $0.contentMode = .scaleAspectFill
                $0.layer.masksToBounds = true
            })
            imageView.backgroundColor = UIColor.gk_random
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge).then({
            $0.hidesWhenStopped = true
            $0.startAnimating()
        })
        addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        
        let pageControl = UIPageControl().then({
            $0.currentPage = 0
            $0.numberOfPages = (imageViews.count - 2)
            $0.currentPageIndicatorTintColor = UIColor(white: 0, alpha: 1.0)
            $0.pageIndicatorTintColor = UIColor(white: 0, alpha: 0.40)
            $0.contentMode = .right
            $0.isHidden = true
            $0.isEnabled = true
            $0.addTarget(self, action: Actions.pageControlAction!, for: .valueChanged)
            $0.sizeToFit()
        })
        addSubview(pageControl)
        self.pageControl = pageControl
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        }
    }
    
    override func removeFromSuperview() {
        scrollView.removeObserver(self, forKeyPath: "contentSize")
        super.removeFromSuperview()
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
        
        activityIndicatorView?.snp.makeConstraints({
            $0.center.equalTo(self.snp.center)
        })
        pageControl?.snp.makeConstraints({
            $0.bottom.equalTo(self.snp.bottom)
            $0.right.equalTo(self.snp.right).offset(-10)
        })
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

extension TopScrollView {
    struct Actions {
        static var pageControlAction: Selector? {
            return #selector(pageControlDidTouched(pageControl:))
        }
    }
    
    func pageControlDidTouched(pageControl: UIPageControl) {
        scrollView.setContentOffset(CGPoint(x: frame.width * CGFloat(pageControl.currentPage + 1), y: 0), animated: true)
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
        self.pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(frame.width) - 1
    }
}
