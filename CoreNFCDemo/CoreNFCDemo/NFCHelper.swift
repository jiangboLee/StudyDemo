//
//  NFCHelper.swift
//  CoreNFCDemo
//
//  Created by ljb48229 on 2018/1/10.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import Foundation
import CoreNFC

class NFCHelper: NSObject, NFCNDEFReaderSessionDelegate{
    
    var onNFCResult: ((Bool, String) -> ())?
    
    func restartSession() {
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        guard let onNFCResult = onNFCResult else { return }
        onNFCResult(false, error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        guard let onNFCResult = onNFCResult else { return }
        for message in messages {
            for recode in message.records {
                if recode.payload.count > 0 {
                    if let payloadString = String.init(data: recode.payload, encoding: .utf8) {
                        onNFCResult(true, payloadString)
                    }
                    
                }
            }
        }
    }
    
    
}
