//
//  SpeechRecognizer.swift
//  Calibration
//
//  Created by Keane Hui on 28/3/2022.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

class SpeechRecognizer: ObservableObject {
    var authorized: Bool
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
    
    @Published var transcript: String
    
    init() {
        self.authorized = false
        self.transcript = ""
    }
    
    deinit {
        reset()
    }
    
    func askPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
                case .authorized:
                    self.authorized = true
                    print("auth set true")
                default:
                    self.authorized = false
                    print("auth set false")
            }
        }
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = true // perform transcription locally
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker, .mixWithOthers])
//        try audioSession.overrideOutputAudioPort(.speaker)
        try audioSession.setAllowHapticsAndSystemSoundsDuringRecording(true)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    func start() throws {
        self.reset()
        do {
            let (new_audioEngine, new_request) = try Self.prepareEngine()
            self.audioEngine = new_audioEngine
            self.request = new_request
            self.recognizer = SFSpeechRecognizer(locale: self.locale)
            startSoundAndHaptic()
            print("Start transcribing...")
            self.task = self.recognizer!.recognitionTask(with: request!) { result, error in
//                let receivedFinalResult = result?.isFinal ?? false
//                let receivedError = error != nil
//                if receivedFinalResult || receivedError {
//                    self.audioEngine?.stop()
//                    self.audioEngine?.inputNode.removeTap(onBus: 0)
//                    if receivedError {
//                        print("Error when transcribing: \(error!.localizedDescription)")
//                    }
//                }
                if let result = result { // update result
                    self.transcript = result.bestTranscription.formattedString
                }
            }
        } catch {
            self.reset()
            print("Error in transcribing: \(error)")
        }
    }
    
    func getTranscript() -> String {
        print("return transcript: \(self.transcript)")
        return self.transcript
    }
    
    func stop() {
        stopSoundAndHaptic()
        reset()
        print("Stop transcribing")
    }
    
    private func reset() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private func startSoundAndHaptic() {
        SoundManager.shared.playSound(filename: "beep.mp3")
        HapticManager.shared.impact(style: .medium)
    }
    
    private func stopSoundAndHaptic() {
        SoundManager.shared.playSound(filename: "double_click.mp3")
        HapticManager.shared.notification(type: .success)
    }
    
}

extension SpeechRecognizer {
    
    var locale: Locale {
        var id = ""
        switch Bundle.main.preferredLocalizations.first! {
        case "en-GB":
            id = "en-GB"
        case "en-US", "en":
            id = "en-US"
        case "zh-Hant-HK":
            id = "zh-HK"
        case "zh-Hant-TW", "zh-Hant":
            id = "zh-TW"
        case "zh-Hans-CN", "zh-Hans":
            id = "zh-CN"
        default:
            id = "en-US"
        }
        return Locale(identifier: id)
    }
    
}
