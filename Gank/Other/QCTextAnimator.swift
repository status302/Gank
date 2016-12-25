//
//  QCTextAnimator.swift
//  Gank
//
//  Created by 程庆春 on 16/6/28.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit
import CoreFoundation
import CoreText

protocol QCTextAnimatorDelegate {
    func animateDidStart(textAnimator: QCTextAnimator, animatorDidStart animator: CAAnimation)
    func animateDidStop(textAnimator: QCTextAnimator, animatorDidStop animator: CAAnimation)

}

class QCTextAnimator: NSObject {

    // MARK: - Private 
    internal var fontName = "Lobster1.4"
    internal var fontSize: CGFloat = 36
    internal var textToAnimate = "Welcome"
    internal var textColor = UIColor.yellowColor()

    internal var delegate: QCTextAnimatorDelegate?

    private var animateLayer = CALayer()
    private var pathLayer: CAShapeLayer?
    private var referenceView : UIView

    init(referenceView: UIView) {
        self.referenceView = referenceView
        super.init()

        defaultConfiguration()
    }

    private func defaultConfiguration() {
        animateLayer = CALayer()

        animateLayer.bounds = referenceView.bounds
        referenceView.layer.addSublayer(animateLayer)

        setupTextWithAnimator(textToAnimate, fontName:fontName, fontSize: fontSize)
    }
    deinit {
        clearLayer()
    }

    func setupTextWithAnimator(text: String, fontName: String,fontSize: CGFloat) {
       /* clearLayer()

        let letters = CGPathCreateMutable()
        let font = CGFontCreateWithFontName(fontName)
        let attrString = NSAttributedString(string: text, attributes: [kCTFontAttributeName as String : font!])
        let line = CTLineCreateWithAttributedString(attrString)
        let runArray = CTLineGetGlyphRuns(line)

        for runIndex in 0 ..<  CFArrayGetCount(runArray) {

            let run: CTRunRef = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), CTRunRef.self)
            let dict: NSDictionary = unsafeBitCast(CTRunGetAttributes(run), CFDictionaryRef.self)

            let runFont = dict[kCTFontAttributeName as String] as! CTFont

            for runGlyphIndex in 0 ..< CTRunGetGlyphCount(run) {

                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph = CGGlyph()

                var position = CGPoint.zero
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)

                CTRunGetPositions(run, thisGlyphRange, &position)
                let letter = CTFontCreatePathForGlyph(runFont, glyph, nil)

                var t = CGAffineTransformMakeTranslation(position.x, position.y)
                CGPathAddPath(letters, &t, letter)
            }
            
            let path = UIBezierPath()
            path.moveToPoint(CGPoint.zero)
            path.appendPath(UIBezierPath(CGPath: letters))

            let pathLayer = CAShapeLayer()
            pathLayer.frame = animateLayer.bounds
            pathLayer.bounds = CGPathGetBoundingBox(path.CGPath)
            pathLayer.geometryFlipped = true
            pathLayer.path = path.CGPath

            pathLayer.fillColor = textColor.CGColor
            pathLayer.strokeColor = UIColor.blackColor().CGColor

            pathLayer.lineWidth = 1.0
            pathLayer.lineCap = kCALineCapRound

            self.pathLayer = pathLayer
            self.animateLayer.addSublayer(pathLayer)

        }
 */
        clearLayer()

        let letters     = CGPathCreateMutable()
        let font        = CTFontCreateWithName(fontName, fontSize, nil)
        let attrString  = NSAttributedString(string: text, attributes: [kCTFontAttributeName as String : font])
        let line        = CTLineCreateWithAttributedString(attrString)
        let runArray    = CTLineGetGlyphRuns(line)

        for runIndex in 0..<CFArrayGetCount(runArray) {

            let run     : CTRunRef =  unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), CTRunRef.self)
            let dictRef : CFDictionaryRef = unsafeBitCast(CTRunGetAttributes(run), CFDictionaryRef.self)
            let dict    : NSDictionary = dictRef as NSDictionary
            let runFont = dict[kCTFontAttributeName as String] as! CTFont

            for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
                let thisGlyphRange  = CFRangeMake(runGlyphIndex, 1)
                var glyph           = CGGlyph()
                var position        = CGPointZero
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                CTRunGetPositions(run, thisGlyphRange, &position)

                let letter          = CTFontCreatePathForGlyph(runFont, glyph, nil)
                var t               = CGAffineTransformMakeTranslation(position.x, position.y)
                CGPathAddPath(letters, &t, letter)
            }
        }

        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.appendPath(UIBezierPath(CGPath: letters))

        let pathLayer               = CAShapeLayer()
        pathLayer.frame             = animateLayer.bounds;
        pathLayer.bounds            = CGPathGetBoundingBox(path.CGPath)
        pathLayer.geometryFlipped   = true
        pathLayer.path              = path.CGPath
        pathLayer.strokeColor       = UIColor.blackColor().CGColor
        pathLayer.fillColor         = textColor.CGColor
        pathLayer.lineWidth         = 1.0
        pathLayer.lineJoin          = kCALineJoinBevel

        self.animateLayer.addSublayer(pathLayer)
        self.pathLayer = pathLayer
    }
    func startAnimation() {
        let duration = 4.0
        pathLayer?.removeAllAnimations()
        setupTextWithAnimator(textToAnimate, fontName: self.fontName, fontSize: self.fontSize)

        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.delegate = self
        pathAnimation.duration = duration
        pathLayer?.addAnimation(pathAnimation, forKey: "strokeEnd")

        let colorDuration = 2.0
        let colorAnimation = CAKeyframeAnimation(keyPath: "fillColor")
        colorAnimation.duration = duration + colorDuration
        colorAnimation.values = [UIColor.clearColor().CGColor, UIColor.clearColor().CGColor, textColor.CGColor]
        colorAnimation.keyTimes = [0, duration / (duration + colorDuration), 1]
        pathLayer?.addAnimation(colorAnimation, forKey: "fillColor")
    }

    func stopAnimation() {
        pathLayer?.removeAllAnimations()
    }
    func clearAnimation() {
        clearLayer()
    }
    private func clearLayer() {
        pathLayer?.removeFromSuperlayer()
        pathLayer = nil
    }

    func updatePathStrokeWithValue(value: CGFloat) {
        pathLayer?.timeOffset = CFTimeInterval(value)
    }

    override func animationDidStart(anim: CAAnimation) {
        self.delegate?.animateDidStart(self, animatorDidStart: anim)
    }
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.delegate?.animateDidStop(self, animatorDidStop: anim)
    }


}
