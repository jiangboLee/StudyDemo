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

    
    var cellRect: CGRect?
    var isHiddenStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailV") as! DetailViewController
            detailVC.transitioningDelegate = self
            detailVC.cellRect = collectionView.convert(cell.frame, to: nil)
            detailVC.backGroundImage = self.coreBlurImage()
            UIView.animate(withDuration: 0.2) {
                
                cell.img.transform = CGAffineTransform.identity
                cell.img.alpha = 0
            }
            self.isHiddenStatus = true
            self.hideTabbar()
            self.hideStatus()
            self.present(detailVC, animated: true, completion: nil)
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
    
    func hideStatus() {
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override var prefersStatusBarHidden: Bool {
        return isHiddenStatus
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isHiddenStatus = false
        hideStatus()
    }
    
/** 2017-12-01 12:57:12
    func showTabbar() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
            var tabFrame = self.tabBarController!.tabBar.frame
            print(tabFrame)
            tabFrame.origin.y = tabFrame.minY - tabFrame.height
            self.tabBarController!.tabBar.frame = tabFrame
            print(self.tabBarController!.tabBar.frame)
        }) { (_) in
            
        }
        print(self.tabBarController!.tabBar.frame)
    }
*/
    
    func coreBlurImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
        collectionView?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
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
        
        return SmallAnimator()
    }
}





