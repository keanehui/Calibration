//
//  File.swift
//  Calibration
//
//  Created by Keane Hui on 7/3/2022.
//

import Foundation
import AVFoundation

class T2SManager {
    static let shared = T2SManager()
    var enabled: Bool
    
    var synthesizer: AVSpeechSynthesizer?
    var utterance: AVSpeechUtterance?
    var rate: Float?
    
    init() {
        let userDefaults = UserDefaults.standard
        self.enabled = userDefaults.bool(forKey: "user_voice_instruction_enabled")
        self.rate = userDefaults.float(forKey: "user_voice_instruction_rate")
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, options: [.duckOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category. \(error.localizedDescription)")
        }
    }
    
    func speakSentence(_ sentence: String, delay: Double = 1.0) {
        if !enabled {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
            self.utterance = AVSpeechUtterance(string: sentence)
            self.utterance!.voice = AVSpeechSynthesisVoice(language: "en-UK")
            self.utterance!.rate = self.rate!
            self.synthesizer?.stopSpeaking(at: .immediate)
            self.synthesizer = AVSpeechSynthesizer()
            self.synthesizer!.speak(self.utterance!)
        }
    }
    
    func stopSpeaking(at boundary: AVSpeechBoundary = .immediate) {
        self.synthesizer?.stopSpeaking(at: boundary)
    }
    
}
