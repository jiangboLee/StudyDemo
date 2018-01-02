//
//  ViewController.swift
//  ReplicatorAnimationDemo
//
//  Created by ljb48229 on 2018/1/2.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
//        animator1()
//        animator2()
        animator3()
    }
    
    func animator3() {
        
        let r = CAReplicatorLayer()
        r.bounds = view.bounds
        r.backgroundColor = UIColor(white: 0, alpha: 0.75).cgColor
        r.position = view.center
        view.layer.addSublayer(r)
        
        let dot = CALayer()
        dot.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        dot.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        dot.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        dot.borderWidth = 1.0
        dot.cornerRadius = 5.0
        dot.shouldRasterize = true
        dot.rasterizationScale = UIScreen.main.scale
        r.addSublayer(dot)
        
        let move = CAKeyframeAnimation(keyPath: "position")
        move.path = rw()
        move.repeatCount = Float.infinity
        move.duration = 2.0
        dot.add(move, forKey: nil)
        
        r.instanceCount = 20
        r.instanceDelay = 0.1
        r.instanceColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1).cgColor
        r.instanceGreenOffset = -0.03;
        
        
    }
    
    func rw() -> CGPath {
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 150, y: 130))
        bezierPath.addLine(to: CGPoint(x: 100, y: 260))
        bezierPath.addLine(to: CGPoint(x: 200, y: 260))
        bezierPath.addLine(to: CGPoint(x: 205, y: 190))
        bezierPath.addLine(to: CGPoint(x: 305, y: 190))
        bezierPath.addArc(withCenter: CGPoint(x: 255, y: 190), radius: 50, startAngle: 0.0, endAngle: CGFloat(Double.pi / 3.0), clockwise: false)
        bezierPath.addLine(to: CGPoint(x: 320, y: 190))
        bezierPath.addLine(to: CGPoint(x: 420, y: 190))
        bezierPath.addArc(withCenter: CGPoint(x: 370, y: 190), radius: 50, startAngle: 0.0, endAngle: CGFloat(Double.pi / 3.0), clockwise: false)
        bezierPath.close()
        
        var t = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        return  bezierPath.cgPath.copy(using: &t)!//CGPathCreateCopyByTransformingPath(bezierPath.cgPath, &t)!
        
    }
    
    func animator2() {
        
        let r = CAReplicatorLayer()
        r.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        r.cornerRadius = 10
        r.backgroundColor = UIColor(white: 0, alpha: 0.75).cgColor
        r.position = view.center
        view.layer.addSublayer(r)
        
        let dot = CALayer()
        dot.bounds = CGRect(x: 0, y: 0, width: 14, height: 14)
        dot.position = CGPoint(x: 100, y: 40)
        dot.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        dot.borderColor = UIColor(white: 1, alpha: 1).cgColor
        dot.borderWidth = 1.0
        dot.cornerRadius = 2.0
        r.addSublayer(dot)
        
        let nrDots: Int = 15
        r.instanceCount = nrDots
        let angle = CGFloat(2 * Double.pi) / CGFloat(nrDots)
        r.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1.0)
        
        let duration: CFTimeInterval = 1.5
        let shrink = CABasicAnimation(keyPath: "transform.scale")
        shrink.fromValue = 1.0
        shrink.toValue = 0.1
        shrink.duration = duration
        shrink.repeatCount = Float.infinity
        dot.add(shrink, forKey: nil)
        
        r.instanceDelay = duration / Double(nrDots)
        dot.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
    }
    
    func animator1() {
        
        let r = CAReplicatorLayer()
        r.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        r.position = CGPoint(x: 200, y: 200)
//        r.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(r)
        
        let bar = CALayer()
        bar.bounds = CGRect(x: 0, y: 0, width: 8, height: 40)
        bar.position = CGPoint(x: 10, y: 75)
        bar.cornerRadius = 2.0
        bar.backgroundColor = UIColor.red.cgColor
        r.addSublayer(bar)
        
        let move = CABasicAnimation(keyPath: "position.y")
        move.toValue = bar.position.y - 35;
        move.duration = 0.5
        move.autoreverses = true
        move.repeatCount = Float.infinity
        bar.add(move, forKey: nil)
        
        r.instanceCount = 3
        r.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        r.instanceDelay = 0.33
        
        //只显示相交的部分
        r.masksToBounds = true
    }
    
}

