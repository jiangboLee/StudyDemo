//
//  ViewController.swift
//  WelocomeAnimator
//
//  Created by ljb48229 on 2018/1/23.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

/** 2018-01-23 11:00:16
https://juejin.im/post/5a31d9696fb9a04500031005
*/

import UIKit

class ViewController: UIViewController, AnimationViewDelegate {

    var animationView = AnimationView(frame: CGRect.zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAnimationView()
    }

    func addAnimationView() {
        let size: CGFloat = 100.0
        animationView.frame = CGRect(x: view.frame.width / 2 - size / 2, y: view.frame.height / 2 - size / 2, width: size, height: size)
        animationView.parentFrame = view.frame
        animationView.delegate = self
        view.addSubview(animationView)
    }
    
    func completeAnimation() {
        // 1
        animationView.removeFromSuperview()
        view.backgroundColor = UIColor.colorWithHexString(hex: "#40e0b0")
        
        // 2
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 50.0)
        label.textAlignment = NSTextAlignment.center
        label.text = "Welcome"
        label.transform = label.transform.scaledBy(x: 0.25, y: 0.25)
        view.addSubview(label)
        
        // 3
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.curveEaseInOut,animations: ({
            
            label.transform = label.transform.scaledBy(x: 4.0, y: 4.0)
        }), completion: { finished in
            self.addTouchButton()
        })
    }
    
    func addTouchButton() {
        let button = UIButton()
        button.frame = CGRect(x: 0.0,y: 0.0,width: view.bounds.width,height: view.bounds.height)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func btnClick() {
        view.backgroundColor = UIColor.white
        view.subviews.forEach { (
            $0.removeFromSuperview()
            )}
        animationView = AnimationView(frame: CGRect.zero)
        addAnimationView()
    }
}

