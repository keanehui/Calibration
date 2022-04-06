//
//  EyeTest2.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI
import AVFoundation

struct HomePageView: View {
    let vi: String = NSLocalizedString("homeVI", comment: "")

    @ObservedObject var appState: AppState
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        VStack(spacing: 30) {
            Text(NSLocalizedString("homePageText", comment: ""))
                .font(.largeTitle)
                .fontWeight(.bold)
            NavigationLink(destination: CalibrationIntroView(appState: appState)) {
                Text(NSLocalizedString("homeStartButton", comment: ""))
            }
            Button {
                openSetting()
            } label: {
                Text(NSLocalizedString("homeSettingButton", comment: ""))
            }
            Button {
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            } label: {
                Text(NSLocalizedString("homePlayButton", comment: ""))
            }
            Button {
                openSetting()
            } label: {
                Text(NSLocalizedString("turnOnVIInSetting", comment: ""))
            }
            .disabled(T2SManager.shared.enabled)
            VStack {
                TextField("Speech Recognizer", text: $speechRecognizer.transcript)
                    .frame(maxWidth: .infinity, maxHeight: 70)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
            }
        }
        .id(appState.rootViewId)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            AudioWaveformWithMic(onTapToStart: startTranscribing, onTapToStop: stopTranscribing)
                .edgesIgnoringSafeArea(.bottom)
                .frame(maxHeight: 100)
        }
        .overlay(alignment: .top) {
            VStack {
                Text(Bundle.main.preferredLocalizations.first!)
                Text(speechRecognizer.locale.identifier)
            }
        }
    }
    
    private func startTranscribing() {
        do {
            try speechRecognizer.start()
        } catch {
            print("error in start transcribing: \(error)")
        }
    }
    
    private func stopTranscribing() {
        speechRecognizer.stop()
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(appState: AppState())
    }
}
