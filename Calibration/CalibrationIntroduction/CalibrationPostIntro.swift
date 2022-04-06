//
//  CalibrationPreIntro.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationPostIntro: View {
    @Binding var distance: Int
    @Binding var isCalibrated: Bool
    @Binding var isSpeaking: Bool
    @ObservedObject var speechRecognizer: SpeechRecognizer
    @ObservedObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    @State private var shouldProceed: Bool = false
    
    private var isListening: Bool {
        speechRecognizer.isListening
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.wave.2.fill").foregroundColor(.blue)
                Image(systemName: "checkmark").padding(.leading).foregroundColor(.green)
                Image(systemName: "iphone").foregroundColor(.gray)
            }
            .font(.system(size: 70))
            Text(NSLocalizedString("postIntroTextTop", comment: ""))
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.top)
            Spacer()
            .disabled(T2SManager.shared.enabled)
            Spacer()
            Text(NSLocalizedString("postIntroTextBottom", comment: ""))
                .font(.title3)
                .multilineTextAlignment(.center)
            NavigationLink(destination: EyeTestMainView(distance: $distance, isCalibrated: $isCalibrated, appState: appState), isActive: $shouldProceed) {
                Text(NSLocalizedString("postIntroButtonTop", comment: ""))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
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
                isCalibrated = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text(NSLocalizedString("postIntroButtonBottom", comment: ""))
                    .padding([.top, .leading, .trailing])
            }
        }
        .onAppear {
            var vi: String = ""
            vi = NSLocalizedString("postIntroVI", comment: "")
            T2SManager.shared.speakSentence(vi, onStart: { isSpeaking = true }, onComplete: startListeningVI)
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in
            if newValue != "" {
                let result = newValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(with: speechRecognizer.locale)
                if result.contains("yes") {
                    stopListeningVI()
                    shouldProceed = true
                } else if result.contains("no") {
                    stopListeningVI()
                    shouldProceed = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        })
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


struct CalibrationPreIntro_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationPostIntro(distance: .constant(40), isCalibrated: .constant(false), isSpeaking: .constant(true), speechRecognizer: SpeechRecognizer(), appState: AppState())
    }
}
