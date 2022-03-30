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

class S2TManager {
    static let shared = S2TManager()
    var authorized: Bool
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?
    
    var transcript: String
    
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
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
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
            self.recognizer = SFSpeechRecognizer(locale: Locale.current)
            HapticManager.shared.impact(style: .medium)
            print("Start transcribing...")
            self.task = self.recognizer!.recognitionTask(with: request!) { result, error in
//                let receivedFinalResult = result?.isFinal ?? false
//                let receivedError = error != nil
//                if receivedFinalResult || receivedError {
//                    self.audioEngine?.stop()
//                    self.audioEngine?.inputNode.removeTap(onBus: 0)
//                    if receivedError {
//                        print("Stop transcribing: \(error!.localizedDescription)")
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
    
    func fetchTranscript(text: inout String) {
        text = self.transcript
        self.transcript = ""
    }
    
    func stop() {
        HapticManager.shared.notification(type: .success)
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
    
}
