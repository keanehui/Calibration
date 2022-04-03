//
//  ContentView.swift
//  Calibration
//
//  Created by Keane Hui on 4/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationIntroView: View {
    @State private var distance: Int = 0
    @State private var isCalibrated: Bool = false
    @State private var isPresenting: Bool = false
    @State private var isShowingVolumeMessage: Bool = false
    @State private var shouldShowWave: Bool = true
    
    var body: some View {
        ZStack(alignment: .center) {
            if (!isCalibrated) {
                CalibrationPreIntro(isPresenting: $isPresenting)
            } else {
                CalibrationPostIntro(distance: $distance, isCalibrated: $isCalibrated)
            }
            if isShowingVolumeMessage {
                VolumeTooLow()
                    .offset(x: 0.0, y: -50.0)
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            }
        }
        .padding()
        .navigationTitle("Calibration")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: isCalibrated) { newValue in
            playVI()
        }
        .onAppear {
            playVI()
        }
        .onDisappear {
            T2SManager.shared.stopSpeaking()
        }
        .sheet(isPresented: $isPresenting) {
            CalibrationMainView(distance: $distance, isCalibrated: $isCalibrated)
        }
    }
    
    private func playVI() {
        let vol = AVAudioSession.sharedInstance().outputVolume
        if T2SManager.shared.enabled && vol == 0.0 {
            HapticManager.shared.notification(type: .warning)
            isShowingVolumeMessage = true
            withAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
                    isShowingVolumeMessage = false
                }
            }
        }
        var vi: String = ""
        let delay = isShowingVolumeMessage ? 3.0 : 0.0
        if !isCalibrated {
            vi = NSLocalizedString("preIntroVI", comment: "")
        } else {
            vi = NSLocalizedString("postIntroVI", comment: "")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
            T2SManager.shared.speakSentence(vi)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationIntroView()
    }
}


