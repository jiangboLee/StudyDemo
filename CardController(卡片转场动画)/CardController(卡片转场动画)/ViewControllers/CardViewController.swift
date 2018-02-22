//
//  CardViewController.swift
//  CardController(卡片转场动画)
//
//  Created by ljb48229 on 2018/1/29.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    
    var pageIndex: Int?
    var petCard: PetCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLable.text = petCard?.description
        cardView.layer.cornerRadius = CardViewController.cardCornerRadius
        cardView.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segueIdentifier(for: segue) == .reveal,
            let destinationViewController = segue.destination as? RevealViewController {
            destinationViewController.petCard = petCard
            //注意，是对被呈现的（presented） view controller 索要 transitioning delegate，而不是对触发呈现动作的（presenting） view controller 进行索要。
            destinationViewController.transitioningDelegate = self
        }
    }

    @IBAction func handleTapAction(_ sender: Any) {
        performSegue(withIdentifier: .reveal, sender: nil)
    }

}

extension CardViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case reveal
    }
}

extension CardViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FilePresentAnimationController(originFrame: cardView.frame)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let revealVC = dismissed as? RevealViewController else { return nil }
        return FlipDismissAnimationController(destinationFrame: cardView.frame, interactionController: revealVC.swipeInteractionController)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? FlipDismissAnimationController,
            let interactionController = animator.interactionController,
            interactionController.interactionInProgress
            else {
                return nil
            }
        return interactionController
    }
}







