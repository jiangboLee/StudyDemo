//
//  CustomButton.swift
//  AppStoreToday
//
//  Created by ljb48229 on 2017/11/30.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            
            if isHighlighted {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform.identity
                })
            }
        }
    }
}
