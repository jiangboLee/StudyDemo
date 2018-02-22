//
//  ContainerViewController.swift
//  SlideDemo(抽屉左滑右滑)
//
//  Created by ljb48229 on 2018/2/22.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }
    
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    
    var leftViewController: SidePanelViewController?
    var rightViewController: SidePanelViewController?
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPannel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    func toggleRightPanel() {
        
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController()
        }
        
        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    func collapseSidePanels() {
        
        switch currentState {
        case .rightPanelExpanded:
            toggleRightPanel()
        case .leftPanelExpanded:
            toggleLeftPannel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        
        guard leftViewController == nil else { return }
        
        if let vc = UIStoryboard.leftVc() {
            vc.animals = Animal.allCats()
            addChildSidePanelController(vc)
            leftViewController = vc
        }
    }
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        
        sidePanelController.delegate = centerViewController
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    func addRightPanelViewController() {
        
        guard rightViewController == nil else { return }
        
        if let vc = UIStoryboard.rightVc() {
            vc.animals = Animal.allDogs()
            addChildSidePanelController(vc)
            rightViewController = vc
        }
    }
    func animateLeftPanel(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    func animateRightPanel(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(targetPosition: -centerNavigationController.view.frame.width + centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
            }
        }
    }
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}
extension ContainerViewController: UIGestureRecognizerDelegate {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = recognizer.velocity(in: view).x > 0
        switch recognizer.state {
        case .began:
            if currentState == .bothCollapsed {
                gestureIsDraggingFromLeftToRight ? addLeftPanelViewController() : addRightPanelViewController()
                showShadowForCenterViewController(true)
            }
        case .changed:
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        case .ended:
            if let _ = leftViewController,
                let rview = recognizer.view {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
                
            }
            if let _ = rightViewController,
                let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.center.x < 0
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
        
    }
    
}

private extension UIStoryboard {
    static func main() -> UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    static func leftVc() -> SidePanelViewController? {
        return main().instantiateViewController(withIdentifier: "SidePanelViewControllerLeft") as? SidePanelViewController
    }
    static func rightVc() -> SidePanelViewController? {
        return main().instantiateViewController(withIdentifier: "SidePanelViewControllerRight") as? SidePanelViewController
    }
    static func centerViewController() -> CenterViewController? {
        return main().instantiateViewController(withIdentifier: "CenterViewController") as? CenterViewController
    }
}
