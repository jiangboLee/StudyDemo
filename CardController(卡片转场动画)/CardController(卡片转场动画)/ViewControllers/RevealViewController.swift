//
//  RevealViewController.swift
//  CardController(卡片转场动画)
//
//  Created by ljb48229 on 2018/1/29.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class RevealViewController: UIViewController {

    var swipeInteractionController: SwipeInteractionController?
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var petCard: PetCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = petCard?.name
        imageView.image = petCard?.image
        
        swipeInteractionController = SwipeInteractionController(viewController: self)
        
    }
    @IBAction func dismissPressAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
