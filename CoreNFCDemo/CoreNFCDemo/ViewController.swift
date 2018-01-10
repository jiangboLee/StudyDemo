//
//  ViewController.swift
//  CoreNFCDemo
//
//  Created by ljb48229 on 2018/1/10.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var payloadLable: UILabel!
    var helper: NFCHelper?
    var payloadText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func onNFCResult(success: Bool, message: String) {
        payloadText = "\(payloadText)\n\(message)"
        DispatchQueue.main.async {
            self.payloadLable.text = self.payloadText
        }
    }

    @IBAction func didTapReadNFC(_ sender: Any) {
        if helper == nil {
            helper = NFCHelper()
            helper?.onNFCResult = self.onNFCResult(success:message:)
        }
        payloadText = ""
        helper?.restartSession()
    }
    
    
}

