//
//  DetailViewController.swift
//  AppStoreToday
//
//  Created by ljb48229 on 2017/11/30.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var isDraging: Bool = false
    var isScale: Bool = false
    
    var backGroundImage: UIImage?
    var cellRect: CGRect?
    var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 20, width: 40, height: 40)
        closeButton.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        closeButton.alpha = 1
        return closeButton
    }()
    
    var panRecongize: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        view.addSubview(closeButton)
        
        let imageV = UIImageView(image: backGroundImage)
        imageV.frame = self.view.bounds
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        blurView.frame = imageV.frame
        imageV.addSubview(blurView)
        
        self.view.insertSubview(imageV, at: 0)
    }
    
    @objc func closeClick() {
        self.closeButton.removeFromSuperview()
        tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}

extension DetailViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableId", for: indexPath)
        
        cell.textLabel?.text = "今天天气真好啊，今天天气真好啊，今天天气真好啊，今天天气真好啊，今天天气真好啊"
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        let scale = y / 800
        
        if isDraging && y >= 0.1 && isScale {
            tableView.transform = CGAffineTransform.identity
            self.tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            restoreCornerRadius()
            return
        }
        if y <= 0 {
            
            scrollView.isScrollEnabled = true
            let transfrom = CGAffineTransform.init(scaleX: 1 + scale * 2 , y: 1 + scale)
            isScale = true
            tableView.transform = transfrom.translatedBy(x: 0, y: y/2)
            
            setCloseButtonChange(sclan: y)
            
            if y == 0 {
                
                restoreCornerRadius()
            } else {
                
                setCornerRadius()
            }
            if y <= -90 {
                closeClick()
            }
            
        } else {
            isScale = false
            scrollView.isScrollEnabled = true
            
        }
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableView.transform = CGAffineTransform.identity
        tableView.bounces = false
        isDraging = false
        isScale = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.bounces = true
        isDraging = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableView.bounces = true
        isScale = false
    }
    
    //MARK: 缩小时到圆角
    func setCornerRadius() {
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        
        let maskPath = UIBezierPath(roundedRect: headerImage.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = headerImage.bounds
        maskLayer.path = maskPath.cgPath
        headerImage.layer.mask = maskLayer
    }
    //MARK: 圆角还原
    func restoreCornerRadius() {
        tableView.layer.masksToBounds = false
        let maskPath = UIBezierPath(roundedRect: headerImage.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 0, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = headerImage.bounds
        maskLayer.path = maskPath.cgPath
        headerImage.layer.mask = maskLayer
    }
    
    func setCloseButtonChange(sclan: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.closeButton.frame = CGRect(x: (UIScreen.main.bounds.width - 50 + UIScreen.main.bounds.width * (sclan / 800)) , y:(20 - sclan), width: 40, height: 40)
            self.closeButton.alpha = 1 + sclan / 90
        }
    }
}



