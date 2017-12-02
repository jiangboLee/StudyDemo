//
//  SmallAnimator.swift
//  AppStoreToday
//
//  Created by ljb48229 on 2017/11/30.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class SmallAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from) as! DetailViewController
        let toViewController = transitionContext.viewController(forKey: .to) as! UITabBarController
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        fromView?.layer.cornerRadius = 20
        fromView?.layer.masksToBounds = true
        
        let todayVC = toViewController.childViewControllers[0] as! TodayController
        
        var H: CGFloat
        if ISIPHONE_X() {
            H = UIScreen.main.bounds.height - 83
        } else {
            H = UIScreen.main.bounds.height - 49
        }
        if (fromViewController.cellRect?.maxY)! > H {
            print("大")
            containerView.insertSubview(toView!, at: 0)
            toView?.addSubview(fromView!)
        } else {
            
            print("小")
            containerView.insertSubview(toView!, belowSubview: fromView!)
        }
        
        let tabBar = toViewController.tabBar
        containerView.addSubview(tabBar)
        tabBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: tabBar.frame.width, height: tabBar.frame.height)
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
            var tabFrame = tabBar.frame
            print("last  \(tabFrame)")
            tabFrame.origin.y = tabFrame.minY - tabFrame.height
            tabBar.frame = tabFrame
            print("last  \(tabBar.frame)")
        }) { (_) in
            
        }
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
            fromView?.frame = CGRect(x: (fromViewController.cellRect?.origin.x)! + 10, y: (fromViewController.cellRect?.origin.y)! + 10, width: (fromViewController.cellRect?.width)! - 20, height: (fromViewController.cellRect?.height)! - 20)
            print(fromView?.frame)
        }) { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dissmissOver"), object: nil)

            fromView?.removeFromSuperview()
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    

}
