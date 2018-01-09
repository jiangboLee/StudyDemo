//
//  TransitionImageView.swift
//  CoreImageChangeDemo
//
//  Created by ljb48229 on 2018/1/2.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit
import CoreImage

class TransitionImageView: UIImageView {

    @IBInspectable var duration: Double = 2.0
    
    private let filter = CIFilter(name: "CICopyMachineTransition")!
    
    private var transitionStartTime: CFTimeInterval = 0.0
    private var transitionTimer: Timer?
    
    func transitionToImage(toImage: UIImage?) {
        guard let image = image, let toImage = toImage else { fatalError("需要图片") }
        
        filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter.setValue(CIImage(image: toImage), forKey: kCIInputTargetImageKey)
        
        if let timer = transitionTimer, timer.isValid {
            timer.invalidate()
        }
        
        transitionStartTime = CACurrentMediaTime()
        transitionTimer = Timer(timeInterval: 1.0 / 30.0, target: self, selector:#selector(timerFired(timer:)), userInfo: toImage, repeats: true)
        RunLoop.current.add(transitionTimer!, forMode: .defaultRunLoopMode)
    }
    
    @objc func timerFired(timer: Timer) {
        
        let progress = (CACurrentMediaTime() - transitionStartTime) / duration
        print(progress)
        filter.setValue(progress, forKey: kCIInputTimeKey)
        
//        image = UIImage(cgImage: filter.outputImage! as! CGImage, scale: UIScreen.main.scale, orientation: UIImageOrientation.up)
        if CACurrentMediaTime() > transitionStartTime + duration {
            image = timer.userInfo as? UIImage
            timer.invalidate()
        }
    }
}














