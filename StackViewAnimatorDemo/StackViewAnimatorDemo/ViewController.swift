//
//  ViewController.swift
//  StackViewAnimatorDemo
//
//  Created by ljb48229 on 2018/1/19.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]! {
        didSet {
            buttons.forEach { (btn) in
                btn.isHidden = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btnClickAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.buttons.forEach({ (btn) in
                btn.isHidden = !btn.isHidden
            })
        }
    }
    
}

