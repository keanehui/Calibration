//
//  CalibrationPostIntro.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationPreIntro: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresenting: Bool
    @Binding var isSpeaking: Bool
    
    @State private var isShowingVolumeMessage: Bool = false
    @ObservedObject var speechRecognizer: SpeechRecognizer
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.wave.2.fill").foregroundColor(.blue)
                Image(systemName: "arrow.left.and.right").padding(.leading).foregroundColor(.orange)
                Image(systemName: "iphone").foregroundColor(.gray)
            }
            .font(.system(size: 70))
            Text(NSLocalizedString("preIntroTextTop", comment: ""))
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.top)
            Spacer()
            Button {
                openSetting()
            } label: {
                Text(NSLocalizedString("turnOnVIInSetting", comment: ""))
            }
            .disabled(T2SManager.shared.enabled)
            Spacer()
            Text(NSLocalizedString("preIntroTextBottom", comment: ""))
                .font(.title3)
            Button {
                isPresenting = true
            } label: {
                Text(NSLocalizedString("preIntroButtonTop", comment: ""))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
                    .overlay(alignment: .trailing) {
                        if isListening {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.red)
                                .padding(5)
                                .background(.ultraThickMaterial, in: Circle())
                                .offset(x: -10, y: 0)
                                .transition(.opacity.animation(.easeInOut))
                        }
                    }
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text(NSLocalizedString("preIntroButtonBottom", comment: ""))
                    .padding([.top, .leading, .trailing])
            }
        }
        .overlay(alignment: .center) {
            if isShowingVolumeMessage {
                VolumeTooLow()
                    .offset(x: 0.0, y: -50.0)
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            }
        }
        .onAppear {
            if !isPresenting {
                checkVolume()
                var vi: String = ""
                vi = NSLocalizedString("preIntroVI", comment: "")
                T2SManager.shared.speakSentence(vi, onStart: { isSpeaking = true }, onComplete: startListeningVI)
            }
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in
            if newValue != "" {
                let result = newValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(with: speechRecognizer.locale)
                if result.contains("yes") {
                    stopListeningVI()
                    isPresenting = true
                } else if result.contains("no") {
                    stopListeningVI()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        })
    }
    
    private func checkVolume() {
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
    }
    
    private func startListeningVI() {
        isSpeaking = false
        withAnimation {
            do {
                try speechRecognizer.start()
            } catch {
                speechRecognizer.reset()
                print("Error in startListeningVI: \(error)")
            }
            
        }
    }
    
    private func stopListeningVI() {
        withAnimation {
            speechRecognizer.stop()
        }
    }
}


struct CalibrationPostIntro_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationPreIntro(isPresenting: .constant(false), isSpeaking: .constant(true), speechRecognizer: SpeechRecognizer())
    }
}
