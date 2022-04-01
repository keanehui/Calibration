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
    @State private var isSpeaking: Bool = false
    
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
                HStack(spacing: 80) {
                    Button {
                        do {
                            try S2TManager.shared.start()
                            isSpeaking = true
                        } catch {
                            print("problem in start transcribing")
                        }
                    } label: {
                        Text("Speak")
                    }
                    Button {
                        S2TManager.shared.stop()
                        isSpeaking = false
                        S2TManager.shared.fetchTranscript(text: &text)
                    } label: {
                        Text("Stop")
                    }
                    Button {
                        isSpeaking = false
                        text = ""
                    } label: {
                        Text("Reset")
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            if isSpeaking {
                AudioWaveform(message: "Answer by saying it to your iPhone. ")
                    .transition(.opacity.animation(.easeInOut))
            }
        }
        .overlay(alignment: .top, content: {
            VStack {
                Text(Bundle.main.preferredLocalizations.first!)
                Text(S2TManager.shared.locale.identifier)
            }
        })
    }
    
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
