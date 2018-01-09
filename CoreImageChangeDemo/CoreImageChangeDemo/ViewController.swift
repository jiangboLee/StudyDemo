//
//  ViewController.swift
//  CoreImageChangeDemo
//
//  Created by ljb48229 on 2018/1/2.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: TransitionImageView!
    var currentImageName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    @objc func didTap() {
        
        currentImageName = (currentImageName == "2") ? "1" : "2"
        imageView.transitionToImage(toImage: UIImage(named: currentImageName))
    }

}

