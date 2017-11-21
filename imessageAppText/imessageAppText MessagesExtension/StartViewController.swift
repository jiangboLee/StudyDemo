//
//  StartViewController.swift
//  imessageAppText MessagesExtension
//
//  Created by ljb48229 on 2017/11/20.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    var onButtonTap: ((UIImage)->Void)?

    @IBAction func sendAction(_ sender: Any) {
        
        onButtonTap?(UIImage.snapshot(from: self.view))
    }
    
}
