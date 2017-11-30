//
//  TodayController.swift
//  AppStoreToday
//
//  Created by ljb48229 on 2017/11/30.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerIdentifier = "header"

class TodayController: UICollectionViewController {

    let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailV") as! DetailViewController
    var cellRect: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailVC.transitioningDelegate = self
        
        var frame = collectionView?.frame
        if ISIPHONE_X() {
            
            frame?.origin.y = 44
        } else {
            
            frame?.origin.y = 20
        }
        collectionView?.frame = frame!
        
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.touchBlock = {[unowned self] in
            
            self.detailVC.cellRect = collectionView.convert(cell.frame, to: nil)
            print(self.detailVC.cellRect)
            self.hideTabbar()
            self.present(self.detailVC, animated: true, completion: nil)
        }
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! HeaderView
            
            
            return header
        }
        return UICollectionReusableView()
    }
    
    func hideTabbar() {
        UIView.animate(withDuration: 0.2) {
            var tabFrame = self.tabBarController!.tabBar.frame
            print(tabFrame)
            tabFrame.origin.y = tabFrame.minY + tabFrame.height
            self.tabBarController!.tabBar.frame = tabFrame
            print(self.tabBarController!.tabBar.frame)
        }
        print(self.tabBarController!.tabBar.frame)
    }
    func showTabbar() {
        UIView.animate(withDuration: 0.4, delay: 2, options: .curveEaseInOut, animations: {
            var tabFrame = self.tabBarController!.tabBar.frame
            print(tabFrame)
            tabFrame.origin.y = tabFrame.minY - tabFrame.height
            self.tabBarController!.tabBar.frame = tabFrame
            print(self.tabBarController!.tabBar.frame)
        }) { (_) in
            
        }
        print(self.tabBarController!.tabBar.frame)
    }
    
    
}

extension TodayController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension TodayController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return BigAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        showTabbar()
        return SmallAnimator()
    }
}





