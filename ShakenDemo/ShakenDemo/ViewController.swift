//
//  ViewController.swift
//  ShakenDemo
//
//  Created by ljb48229 on 2018/1/11.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit
import AudioToolbox
class ViewController: UIViewController {
    
    //指定一个全局变量来保存类的地址，在通过类的地址找到类方法（函数）的地址调用
    static var selfClass: ViewController? = nil
    @IBOutlet weak var shakenLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.selfClass = self
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }
    //摇一摇结束回调 还有begin/cancel2个方法
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            palySound()
            shakenLable.text = "shakening......"
        }
    }
    
    func palySound() {
        
        let audioStr = Bundle.main.path(forResource: "3", ofType: "mp3")
        let audioPath = NSURL(fileURLWithPath: audioStr!)
        var soundID: SystemSoundID = 0
        //自定义系统声音
        AudioServicesCreateSystemSoundID(audioPath, &soundID)
        //声音结束后回调方法，指定soundID对应的回调方法
        AudioServicesAddSystemSoundCompletion(soundID, nil, nil, { (soundID, rawPoints) in
            //声音结束后取消方法，
            //在这里有个坑，就是c代码里要调用swift方法
            NSObject.cancelPreviousPerformRequests(withTarget: ViewController.selfClass!, selector: #selector(ViewController.selfClass?.palyVibrate), object: nil)
        }, nil)
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        //发出声音
        AudioServicesPlaySystemSound(soundID)
        
        self.perform(#selector(self.palyVibrate), with: nil, afterDelay: 1)
    }
    
    @objc func palyVibrate() {
        //利用递归，1秒后再震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) //震动
        self.perform(#selector(self.palyVibrate), with: nil, afterDelay: 1)
    }
}

