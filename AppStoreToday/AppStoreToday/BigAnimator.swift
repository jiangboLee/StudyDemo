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
        return 10
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to) as! DetailViewController
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        
        toView?.frame = toViewController.cellRect!
        containerView.addSubview(toView!)
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            
            toView?.frame = UIScreen.main.bounds
        }) { (_) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
        
        
    }
}
