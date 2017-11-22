//
//  SpeechTranscriber.swift
//  SpeechDemo
//
//  Created by ljb48229 on 2017/11/21.
//  Copyright © 2017年 ljb48229. All rights reserved.
//

import Foundation
import Speech

class SpeechTranscriber {
    
    private(set) var isTranscribing: Bool = false
    
    var onTranscriptionCompletion: ((String) -> ())?
    
    init() {
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            if status == .authorized {
                print("ok~~~~")
            } else {
                fatalError("sorry~~~~~")
            }
        }
        
    }
    
    public func start() {
        
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        
    }
    
    private func createAudioSession(onNewBufferReceived: (AVAudioPCMBuffer) -> ()) throws {
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        
    }
}



















