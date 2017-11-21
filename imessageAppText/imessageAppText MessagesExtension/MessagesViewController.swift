//
//  MessagesViewController.swift
//  imessageAppText MessagesExtension
//
//  Created by ljb48229 on 2017/11/20.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // MARK: - Conversation Handling
    override func willBecomeActive(with conversation: MSConversation) {
        
        configureChildViewController(for: presentationStyle, with: conversation)
    }
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        
    }
}

extension MessagesViewController {
    fileprivate func configureChildViewController(for presentationStyle: MSMessagesAppPresentationStyle, with conversation: MSConversation) {
        
        // Remove any existing child view controllers
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Now let's create our new one
        let childViewController: UIViewController
        
        switch presentationStyle {
        case .compact:
            childViewController = createStartViewController(with: conversation)
        case .expanded: 
            if let message = conversation.selectedMessage,
                let url = message.url {
                childViewController = UIViewController()
                childViewController.view.backgroundColor = UIColor.yellow
                print(url)
            }
            else {
                
                childViewController = UIViewController()
                childViewController.view.backgroundColor = UIColor.red
            }
            
        case .transcript:
            childViewController = UIViewController()
            break;
        }
        
        // Add controller
        addChildViewController(childViewController)
        childViewController.view.frame = view.bounds
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        
        childViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        childViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        childViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        childViewController.didMove(toParentViewController: self)
    }
    
//    fileprivate func createShipLocationViewController(with conversation: MSConversation) -> UIViewController {
//        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ShipLocationViewController") as? ShipLocationViewController else {
//            fatalError("Cannot instantiate view controller")
//        }
//
//        controller.onLocationSelectionComplete = {
//            [unowned self]
//            model, snapshot in
//
//            let session = MSSession()
//            let caption = "$\(conversation.localParticipantIdentifier) placed their ships! Can you find them?"
//
//            self.insertMessageWith(caption: caption, model, session, snapshot, in: conversation)
//
//            self.dismiss()
//        }
//
//        return controller
//    }
//
//    fileprivate func createShipDestroyViewController(with conversation: MSConversation, model: GameModel) -> UIViewController {
//        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ShipDestroyViewController") as? ShipDestroyViewController else {
//            fatalError("Cannot instantiate view controller")
//        }
//
//        controller.model = model
//        controller.onGameCompletion = {
//            [unowned self]
//            model, playerWon, snapshot in
//
//            if let message = conversation.selectedMessage,
//                let session = message.session {
//                let player = "$\(conversation.localParticipantIdentifier)"
//                let caption = playerWon ? "\(player) destroyed all the ships!" : "\(player) lost!"
//
//                self.insertMessageWith(caption: caption, model, session, snapshot, in: conversation)
//            }
//
//            self.dismiss()
//        }
//
//        return controller
//    }
    
    fileprivate func createStartViewController(with conversation: MSConversation) -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        controller.onButtonTap = {
           [unowned self] snapshot in
            
            let session = MSSession()
            let caption = "num1"
            
            let message = MSMessage(session: session)
            let template = MSMessageTemplateLayout()
            template.image = snapshot
            template.caption = caption
            message.layout = template
            message.url = NSURL(string: "https://www.baidu.com")! as URL
            conversation.insert(message, completionHandler: nil)
        }
        
        return controller
    }
}










