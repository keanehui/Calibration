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

    @State private var text: String = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text(NSLocalizedString("homePageText", comment: ""))
                .font(.largeTitle)
                .fontWeight(.bold)
            NavigationLink(destination: CalibrationIntroView()) {
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
            VStack {
                TextField("Speech Recognizer", text: $text)
                    .frame(maxWidth: .infinity, maxHeight: 70)
                    .textFieldStyle(.roundedBorder)
                    .disabled(true)
            }
        }
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
                Text(S2TManager.shared.locale.identifier)
            }
        }
    }
    
    private func startTranscribing() {
        do {
            try S2TManager.shared.start()
        } catch {
            print("problem in start transcribing")
        }
    }
    
    private func stopTranscribing() {
        S2TManager.shared.stop()
        text = S2TManager.shared.getTranscript()
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
