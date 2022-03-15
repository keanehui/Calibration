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
    var pitchMultiplier: Float?
    var voice: AVSpeechSynthesisVoice?
    
    init() {
        let userDefaults = UserDefaults.standard
        self.enabled = userDefaults.bool(forKey: "user_voice_instruction_enabled")
        self.rate = userDefaults.float(forKey: "user_voice_instruction_rate")
        self.pitchMultiplier = userDefaults.float(forKey: "user_voice_instruction_pitch")
        self.voice = AVSpeechSynthesisVoice(identifier: getVoiceId())
        
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
            self.utterance!.rate = self.rate!
            self.utterance!.pitchMultiplier = self.pitchMultiplier!
            self.utterance!.voice = self.voice!
            self.synthesizer?.stopSpeaking(at: .immediate)
            self.synthesizer = AVSpeechSynthesizer()
            self.synthesizer!.speak(self.utterance!)
        }
    }
    
    func stopSpeaking(at boundary: AVSpeechBoundary = .immediate) {
        self.synthesizer?.stopSpeaking(at: boundary)
    }
    
    private func getVoiceId() -> String {
        let language_id: String? = Bundle.main.preferredLocalizations.first
        var id: String = ""
        switch language_id {
        case "en-GB":
            id = "com.apple.ttsbundle.siri_Martha_en-GB_compact"
        case "en-US", "en":
            id = AVSpeechSynthesisVoiceIdentifierAlex
        case "zh-Hant-HK":
            id = "com.apple.ttsbundle.Sin-Ji-compact"
        case "zh-Hant-TW", "zh-Hant":
            id = "com.apple.ttsbundle.Mei-Jia-compact"
        case "zh-Hans-CN", "zh-Hans":
            id = "com.apple.ttsbundle.Ting-Ting-compact"
        default:
            id = AVSpeechSynthesisVoiceIdentifierAlex
        }
        return id
    }
    
    
}
