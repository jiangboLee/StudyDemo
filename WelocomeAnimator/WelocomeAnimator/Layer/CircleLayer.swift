//
//  CircleLayer.swift
//  WelocomeAnimator
//
//  Created by ljb48229 on 2018/1/23.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class CircleLayer: CAShapeLayer {
    
    let KAnimationDuration: CFTimeInterval = 0.3
    let KAnimationBeginTime: CFTimeInterval = 0.0
    
    override init() {
        super.init()
        self.fillColor = UIColor.colorWithHexString(hex: "#da70d6").cgColor
        self.path = circleSmallPath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var circleSmallPath: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: 50, y: 50, width: 0, height: 0))
    }
    var circleBigPath: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: 2.5, y: 17.5, width: 95.0, height: 95.0))
    }
    var circleVerticalSquishPath: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: 2.5, y: 20.0, width: 95.0, height: 90.0))
    }
    var circleHorizontalSquishPath: UIBezierPath {
        return UIBezierPath(ovalIn: CGRect(x: 5.0, y: 20.0, width: 90.0, height: 90.0))
    }
    
    func expand() {
        let expandAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        expandAnimation.fromValue = circleSmallPath.cgPath
        expandAnimation.toValue = circleBigPath.cgPath
        expandAnimation.duration = KAnimationDuration
        expandAnimation.fillMode = kCAFillModeForwards
        expandAnimation.isRemovedOnCompletion = false
        self.add(expandAnimation, forKey: nil)
    }
    
    func shakeAnimation() {
        let animation1: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation1.fromValue = circleBigPath.cgPath
        animation1.toValue = circleVerticalSquishPath.cgPath
        animation1.beginTime = KAnimationBeginTime
        animation1.duration = KAnimationDuration
        
        let animation2: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation2.fromValue = circleVerticalSquishPath.cgPath
        animation2.toValue = circleHorizontalSquishPath.cgPath
        animation2.beginTime = animation1.duration + animation1.beginTime
        animation2.duration = KAnimationDuration
        
        let animation3: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation3.fromValue = circleHorizontalSquishPath.cgPath
        animation3.toValue = circleVerticalSquishPath.cgPath
        animation3.beginTime = animation2.duration + animation2.beginTime
        animation3.duration = KAnimationDuration
        
        let animation4: CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation4.fromValue = circleVerticalSquishPath.cgPath
        animation4.toValue = circleBigPath.cgPath
        animation4.beginTime = animation3.duration + animation3.beginTime
        animation4.duration = KAnimationDuration
        
        let animationGrop: CAAnimationGroup = CAAnimationGroup()
        animationGrop.animations = [animation1, animation2, animation3, animation4]
        animationGrop.duration = 4 * KAnimationDuration
        animationGrop.repeatCount = 2
        add(animationGrop, forKey: nil)
        
    }
    
    func contract() {
        let contractAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        contractAnimation.fromValue = circleBigPath.cgPath
        contractAnimation.toValue = circleSmallPath.cgPath
        contractAnimation.duration = KAnimationDuration
        contractAnimation.fillMode = kCAFillModeForwards
        contractAnimation.isRemovedOnCompletion = false
        add(contractAnimation, forKey: nil)
    }
}








