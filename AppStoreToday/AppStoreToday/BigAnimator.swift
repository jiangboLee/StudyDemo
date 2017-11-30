//
//  BigAnimator.swift
//  AppStoreToday
//
//  Created by ljb48229 on 2017/11/30.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class BigAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var cellRect: CGRect?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to) as! DetailViewController
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        toView?.frame = CGRect(x: (toViewController.cellRect?.origin.x)! + 10, y: (toViewController.cellRect?.origin.y)!, width: (toViewController.cellRect?.width)! - 20, height: (toViewController.cellRect?.height)!)
        print(toView?.frame)
        containerView.addSubview(toView!)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            toView?.frame = CGRect(x: (toViewController.cellRect?.origin.x)! + 10, y: 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 20)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: transitionDuration - 0.15, delay: 0.15, usingSpringWithDamping: 20, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            toView?.frame = UIScreen.main.bounds
        }) { (_) in
            
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
        
        
    }
}
