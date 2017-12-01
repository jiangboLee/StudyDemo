//
//  DetailViewController.swift
//  AppStoreToday
//
//  Created by ljb48229 on 2017/11/30.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var isDraging: Bool = false
    var isScale: Bool = false
    
    var backGroundImage: UIImage?
    var cellRect: CGRect?
    var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 40, width: 20, height: 20)
        closeButton.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        closeButton.alpha = 1
        return closeButton
    }()
    
    var panRecongize: UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(closeButton)
        
        let imageV = UIImageView(image: backGroundImage)
        imageV.frame = self.view.bounds
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        blurView.frame = imageV.frame
        imageV.addSubview(blurView)
        
        self.view.insertSubview(imageV, at: 0)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panMove(recognize:)))
        panRecongize = pan
        pan.delegate = self
        tableView.addGestureRecognizer(pan)
    }
    
    @objc func closeClick() {
        self.closeButton.alpha = 0
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}

extension DetailViewController: UITableViewDelegate,UITableViewDataSource {
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableId", for: indexPath)
        
        cell.textLabel?.text = "今天天气真好啊，今天天气真好啊，今天天气真好啊，今天天气真好啊，今天天气真好啊"
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let y = scrollView.contentOffset.y
        print("====\(y)")
        let scale = y / 800
        
        if y <= 0 {
            
            scrollView.isScrollEnabled = true
            let transfrom = CGAffineTransform.init(scaleX: 1 + scale , y: 1 + scale)
            isScale = true
            tableView.transform = transfrom.translatedBy(x: 0, y: y/2)
//            tableView.addGestureRecognizer(panRecongize!)
//            panMove(recognize: panRecongize!)
            if y <= -90 {
                closeClick()
            }
            
        } else {
            isScale = false
            scrollView.isScrollEnabled = true
            tableView.removeGestureRecognizer(panRecongize!)
        }
        if isDraging && y >= 0 && isScale {
            scrollView.isScrollEnabled = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableView.transform = CGAffineTransform.identity
        tableView.bounces = false
        isDraging = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.bounces = true
        isDraging = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableView.bounces = true
    }
    
    @objc func panMove(recognize: UIPanGestureRecognizer) {
        
        let translatedPoint = recognize.translation(in: tableView)
        let y = translatedPoint.y
        print(y)
        let scale = y / 800
        if y < -2  {
            tableView.transform = CGAffineTransform.identity
            tableView.isScrollEnabled = true
        } else {
            tableView.transform = CGAffineTransform.init(scaleX: 1 - scale , y: 1 - scale)
            tableView.isScrollEnabled = false
            isScale = true
            
           
            switch recognize.state {
            case .cancelled:
                tableView.transform = CGAffineTransform.identity
                tableView.isScrollEnabled = true
            case .ended:
                tableView.transform = CGAffineTransform.identity
                tableView.isScrollEnabled = true
            case .failed:
                tableView.transform = CGAffineTransform.identity
                tableView.isScrollEnabled = true
            default:
                break
            }
            
            
            if y >= 175 {
                tableView.removeGestureRecognizer(recognize)
                tableView.transform = CGAffineTransform.identity
                view.layoutIfNeeded()
                closeClick()
            }
        }
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}



