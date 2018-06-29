//
//  ViewController.swift
// Touch3dButton
//
//  Created by ljb48229 on 2018/2/27.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func deleteAction() {
        
        UIAlertView(title: nil, message: "已删除", delegate: nil, cancelButtonTitle: "确定").show()
        
    }
    
    
}

