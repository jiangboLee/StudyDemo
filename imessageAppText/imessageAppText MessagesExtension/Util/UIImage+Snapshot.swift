//
//  UIImage+Snapshot.swift
//  imessageAppText MessagesExtension
//
//  Created by ljb48229 on 2017/11/20.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func snapshot(from view:UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return snapshot!
        
    }
}
