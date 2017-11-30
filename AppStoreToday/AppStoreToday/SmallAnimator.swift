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
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from) as! DetailViewController
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        
        
        containerView.insertSubview(toView!, belowSubview: fromView!)
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, delay: 0, options: .curveEaseInOut, animations: {
            
            fromView?.frame = CGRect(x: (fromViewController.cellRect?.origin.x)! + 10, y: (fromViewController.cellRect?.origin.y)! + 10, width: (fromViewController.cellRect?.width)! - 20, height: (fromViewController.cellRect?.height)! - 20)
        }) { (_) in
            fromView?.removeFromSuperview()
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    

}
