//
//  CustomLayout.swift
//  CollectionCustomLayoutDemo
//
//  Created by ljb48229 on 2017/11/23.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewLayout {

    enum Element: String {
        case header
        case menu
        case sectionHeader
        case sectionFooter
        case cell
        
        var id: String {
            return self.rawValue
        }
        
        var kind: String {
            return "Kind\(self.rawValue.capitalized)"
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    //MARK: - properties
    var settings = CustomLayoutSettings()
    private var oldBounds = CGRect.zero
    private var contentHeight = CGFloat()
    private var cache = [Element: [IndexPath: CustomLayoutAttributes]]()
    private var visibleLayoutAttributes = [CustomLayoutAttributes]()
    private var zIndex = 0
    
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }
    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
    }
    private var cellHeight: CGFloat {
        guard let itemSize = settings.itemSize else { return collectionViewHeight }
        return itemSize.height
    }
    private var cellWidth: CGFloat {
        guard let itemSize = settings.itemSize else { return collectionViewWidth }
        return itemSize.width
    }
    
    private var headerSize: CGSize {
        guard let headerSize = settings.headerSize else { return .zero }
        return headerSize
    }
    private var menuSize: CGSize {
        guard let menuSize = settings.menuSize else { return .zero }
        return menuSize
    }
    
    private var sectionsHeaderSize: CGSize {
        guard let sectionsHeaderSize = settings.sectionsHeaderSize else { return .zero }
        return sectionsHeaderSize
    }
    private var sectionsFooterSize: CGSize {
        guard let sectionsFooterSize = settings.sectionsFooterSize else { return .zero }
        return sectionsFooterSize
    }
    
    private var contentOffset: CGPoint {
        return collectionView!.contentOffset
    }
}

extension CustomLayout {
    //你可以对元素在布局中的位置进行计算
    override func prepare() {
        
        guard let collectionView = collectionView, cache.isEmpty else { return }
        
        prepareCache()
        
        contentHeight = 0
        zIndex = 0
        oldBounds = collectionView.bounds
        let itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        let headerAttributes = CustomLayoutAttributes(forSupplementaryViewOfKind: Element.header.kind, with: IndexPath(item: 0, section: 0))
        prepareElement(size: headerSize, type: .header, attributes: headerAttributes)
        
        let menuAttributes = CustomLayoutAttributes(forSupplementaryViewOfKind: Element.menu.kind, with: IndexPath(item: 0, section: 0))
        prepareElement(size: menuSize, type: .menu, attributes: menuAttributes)
        
        for section in 0 ..< collectionView.numberOfSections {
            
            let sectionHeaderAttributes = CustomLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                with: IndexPath(item: 0, section: section))
            prepareElement(
                size: sectionsHeaderSize,
                type: .sectionHeader,
                attributes: sectionHeaderAttributes)
            
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let cellIndexPath = IndexPath(item: item, section: section)
                let attributes = CustomLayoutAttributes(forCellWith: cellIndexPath)
                let lineInterSpace = settings.minimumLineSpacing
                attributes.frame = CGRect(
                    x: 0 + settings.minimumInteritemSpacing,
                    y: contentHeight + lineInterSpace,
                    width: itemSize.width,
                    height: itemSize.height
                )
                attributes.zIndex = zIndex
                contentHeight = attributes.frame.maxY
                cache[.cell]?[cellIndexPath] = attributes
                zIndex += 1
            }
            
            let sectionFooterAttributes = CustomLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                with: IndexPath(item: 1, section: section))
            prepareElement(
                size: sectionsFooterSize,
                type: .sectionFooter,
                attributes: sectionFooterAttributes)
        }
        
        updateZIndexes()
        
    }
    private func prepareCache() {
        cache.removeAll(keepingCapacity: true)
        cache[.header] = [IndexPath: CustomLayoutAttributes]()
        cache[.menu] = [IndexPath: CustomLayoutAttributes]()
        cache[.sectionHeader] = [IndexPath: CustomLayoutAttributes]()
        cache[.sectionFooter] = [IndexPath: CustomLayoutAttributes]()
        cache[.cell] = [IndexPath: CustomLayoutAttributes]()
    }
    //决定了 CustomLayout 对象何时需要或如何再次执行核心处理
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if oldBounds.size != newBounds.size {
            cache.removeAll(keepingCapacity: true)
        }
        return true
    }
    
    private func prepareElement(size: CGSize, type: Element, attributes: CustomLayoutAttributes) {
        guard size != .zero else {
            return
        }
        attributes.initialOrigin = CGPoint(x: 0, y: contentHeight)
        attributes.frame = CGRect(origin: attributes.initialOrigin, size: size)
        
        attributes.zIndex = zIndex
        zIndex += 1
        
        contentHeight = attributes.frame.maxY
        
        cache[type]?[attributes.indexPath] = attributes
    }
    
    private func updateZIndexes(){
        guard let sectionHeaders = cache[.sectionHeader] else { return }
        
        var sectionHeadersZIndex = zIndex
        for (_, attributes) in sectionHeaders {
            attributes.zIndex = sectionHeadersZIndex
            sectionHeadersZIndex += 1
        }
        
        cache[.menu]?.first?.value.zIndex = sectionHeadersZIndex
    }
    
}





















