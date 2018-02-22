//
//  CenterViewController.swift
//  SlideDemo(抽屉左滑右滑)
//
//  Created by ljb48229 on 2018/2/22.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

//http://blog.csdn.net/kmyhy/article/details/79310506

import UIKit

class CenterViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: CenterViewControllerDelegate?
    
    @IBAction func leftClick(_ sender: Any) {
        delegate?.toggleLeftPannel?()
    }
    
    @IBAction func rightClick(_ sender: Any) {
        delegate?.toggleRightPanel?()
    }
}

extension CenterViewController: SidePanelViewControllerDelegate {
    
    func didSelectAnimal(_ animal: Animal) {
        imageView.image = animal.image
        delegate?.collapseSidePanels?()
    }
}
