//
//  CollectionViewCell.swift
//  AppStoreToday
//
//  Created by ljb48229 on 2017/11/30.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    

    @IBOutlet weak var img: UIImageView!
    
    var touchBlock: (()->())?
    
    override func awakeFromNib() {
        
        img.layer.cornerRadius = 20
        img.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            
            self.img.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }
        print("begin")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        print("move")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            
            self.img.transform = CGAffineTransform.identity
        }
        print("cancel")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touchBlock?()
    }
    
}
