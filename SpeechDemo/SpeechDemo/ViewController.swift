//
//  ViewController.swift
//  SpeechDemo
//
//  Created by ljb48229 on 2017/11/21.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var speechLable: UILabel!
    
    @IBOutlet weak var moveView: UIView!
    
    
    let transcriber = SpeechTranscriber()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func directionsButtonClickAction(_ sender: Any) {
        
        if !transcriber.isTranscribing {
            
        } else {
            
        }
    }
    
    
}

