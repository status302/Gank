//
//  CustomRefreshControl.swift
//  PullRefresh
//
//  Created by 程庆春 on 16/6/8.
//  Copyright © 2016年 Appcoda. All rights reserved.
//

import UIKit

class CustomRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        
        backgroundColor = UIColor.clearColor()
        tintColor = UIColor.clearColor()

        loadCustomView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var customView: UIView!
    private var labelsArray = [UILabel]()

    private var currentColorIndex = 0
    private var currentLabelIndex = 0

    var isAnimating = false

    var timer: NSTimer!

    func doTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(endWork), userInfo: nil, repeats: true)
    }

    func endWork() {
        endRefreshing()
        timer.invalidate()
        timer = nil
    }

    func startAnimation() {
        setupAnimationToRetota()
        doTimer()
    }


    private func loadCustomView() {
        let customContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: nil, options: nil)

        customView = customContents[0] as! UIView
        customView.backgroundColor = UIColor.whiteColor()
        customView.frame = self.bounds
        for i in 0..<customView.subviews.count {
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        self.addSubview(customView)
    }

    func setupAnimationToRetota() {

        isAnimating = true

        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear, animations: { 
                self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            self.labelsArray[self.currentColorIndex].textColor = self.getNextColor()
            }) { (finished) in
                self.currentLabelIndex += 1
                if self.currentLabelIndex < self.labelsArray.count {
                    self.setupAnimationToRetota()
                } else {
                    self.setupAnimationScaleAndChangeColor()
                }
        }
    }

    func setupAnimationScaleAndChangeColor() {
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveLinear, animations: {
            self.labelsArray[0].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[1].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[2].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[3].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[4].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[5].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[6].transform = CGAffineTransformMakeScale(1.5, 1.5)

        }) { (finished) in
            UIView.animateWithDuration(0.25, delay: 0, options: .CurveLinear, animations: { 

                self.labelsArray[0].transform = CGAffineTransformIdentity
                self.labelsArray[1].transform = CGAffineTransformIdentity
                self.labelsArray[2].transform = CGAffineTransformIdentity
                self.labelsArray[3].transform = CGAffineTransformIdentity
                self.labelsArray[4].transform = CGAffineTransformIdentity
                self.labelsArray[5].transform = CGAffineTransformIdentity
                self.labelsArray[6].transform = CGAffineTransformIdentity

                }, completion: { (finished) in
                    if self.refreshing {
                        self.currentLabelIndex = 0
                        self.setupAnimationToRetota()
                    } else {
                        self.isAnimating = false
                        self.currentLabelIndex = 0
                        for label in self.labelsArray {
                            label.transform = CGAffineTransformIdentity
                            label.textColor = UIColor.blackColor()
                        }
                    }
            })
        }
    }
    func getNextColor() -> UIColor {
        var colorsArray = [UIColor.redColor(), UIColor.blueColor(), UIColor.magentaColor(),
                            UIColor.brownColor(), UIColor.greenColor(), UIColor.lightGrayColor(),
                        UIColor.orangeColor()]

        let returnColor = colorsArray[currentColorIndex]
        currentColorIndex += 1
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        return returnColor
    }


}
