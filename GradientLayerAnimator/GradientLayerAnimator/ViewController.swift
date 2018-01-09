//
//  ViewController.swift
//  GradientLayerAnimator
//
//  Created by ljb48229 on 2018/1/9.
//  Copyright © 2018年 ljb48229. All rights reserved.
//
//http://blog.csdn.net/kmyhy/article/details/78988766
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lable: UILabel!
    
    var gradient: CAGradientLayer = CAGradientLayer()
    var textCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.frame = view.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.colors = [UIColor(red: 0.0, green: 1.0, blue: 0.7, alpha: 1.0).cgColor, UIColor(red: 0.94, green: 0.03, blue: 0.93, alpha: 1.0).cgColor]
        view.layer.addSublayer(gradient)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gradient.mask = lable.layer
        
        let meImage = UIImageView(image: #imageLiteral(resourceName: "me"))
        meImage.center.x = lable.bounds.width / 2
        meImage.center.y = -10
        meImage.bounds.size = CGSize(width: 200, height: 200)
        lable.addSubview(meImage)
        
        lable.text = ""
        punchText(text: "我完成的家家户户vjhdskfklfjk 的开始放假的空间发的空间房间可是看到你你你息怒息怒心心念念明星妈妈小非农防腐剂匹配哦哦融捷股份女女女付款覅额非把审计快来吧vajblfjkadsbfdjbznabvnabbvks")
    }
    
    func punchText(text: String) {
        if text.count > self.textCount {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.04, execute: {
                self.textCount += 1
                let endIndex = text.index(text.startIndex, offsetBy: self.textCount)
                self.punchText(text: text)
                self.lable.text = String(text[..<endIndex])
            })
        } else {
            
            perform(#selector(addButtonRing), with: nil, afterDelay: 0.1)
            perform(#selector(addButtonRing), with: nil, afterDelay: 1.2)
            perform(#selector(addButtonRing), with: nil, afterDelay: 2.4)
            
        }
    }
    
    @objc func addButtonRing() {
        
        let side: CGFloat = 60.0
        let button = CAShapeLayer()
        button.position = CGPoint(x: lable.bounds.width / 2.0 - side / 2.0, y: lable.bounds.height * 0.85)
        button.strokeColor = UIColor.black.cgColor
        button.fillColor = UIColor.clear.cgColor
        button.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: side, height: side)).cgPath
        button.lineWidth = 1.0
        button.opacity = 0.5
        lable.layer.addSublayer(button)
        
        //添加动画
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = 0.67
        scale.duration = 2.0
        scale.repeatCount = Float.infinity
        scale.autoreverses = true
        button.add(scale, forKey: nil)
    }
    
}












