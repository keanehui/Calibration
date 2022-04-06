//
//  ContentView.swift
//  Calibration
//
//  Created by Keane Hui on 4/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationIntroView: View {
    @ObservedObject var appState: AppState
    @State private var distance: Int = 0
    @State private var isCalibrated: Bool = false
    @State private var isPresenting: Bool = false
    @State private var isSpeaking: Bool = false
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if (!isCalibrated) {
                CalibrationPreIntro(isPresenting: $isPresenting, isSpeaking: $isSpeaking, speechRecognizer: speechRecognizer)
            } else {
                CalibrationPostIntro(distance: $distance, isCalibrated: $isCalibrated, isSpeaking: $isSpeaking, speechRecognizer: speechRecognizer, appState: appState)
            }
        }
        .padding()
        .navigationTitle("Calibration")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            T2SManager.shared.stopSpeaking()
            T2SManager.shared.resetHandler()
        }
        .sheet(isPresented: $isPresenting) {
            CalibrationMainView(distance: $distance, isCalibrated: $isCalibrated)
        }
        .overlay(alignment: .topTrailing) {
            if isListening {
                MicAnimation(size: 30)
                    .padding()
            }
        }
        .overlay(alignment: .topLeading) {
            if isSpeaking {
                SpeakerAnimation(size: 30)
                    .padding()
            }
        }
        .overlay(alignment: .bottom) {
            if isListening {
                AudioWaveform(amplify1: 30, amplify2: 15)
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .transition(.offset(x: 0, y: 100).animation(.easeInOut))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationIntroView(appState: AppState())
    }
}


