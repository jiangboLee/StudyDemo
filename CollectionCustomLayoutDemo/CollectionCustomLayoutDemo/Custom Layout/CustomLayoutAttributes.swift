//
//  CustomLayoutAttributes.swift
//  CollectionCustomLayoutDemo
//
//  Created by ljb48229 on 2017/11/24.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class CustomLayoutAttributes: UICollectionViewLayoutAttributes {

    // MARK: - Properties
    var parallax: CGAffineTransform = .identity
    var initialOrigin: CGPoint = .zero
    var headerOverlayAlpha = CGFloat(0)
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? CustomLayoutAttributes else { return super.copy(with: zone) }
        
        copiedAttributes.parallax = parallax
        copiedAttributes.initialOrigin = initialOrigin
        copiedAttributes.headerOverlayAlpha = headerOverlayAlpha
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? CustomLayoutAttributes else {
            return false
        }
        
        if NSValue(cgAffineTransform: otherAttributes.parallax) != NSValue(cgAffineTransform: parallax)
            || otherAttributes.initialOrigin != initialOrigin
            || otherAttributes.headerOverlayAlpha != headerOverlayAlpha {
            return false
        }
        
        return super.isEqual(object)
    }
}
