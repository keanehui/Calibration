//
//  CalibrationMainView.swift
//  Calibration
//
//  Created by Keane Hui on 4/2/2022.
//

import SwiftUI
import AVFoundation
import Combine

struct CalibrationMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var distance: Int
    @Binding var isCalibrated: Bool
    @State private var secondsSinceValid: CGFloat = 0.0
    @State private var timerSubscription: Cancellable?
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var distanceStatus: DistanceStatus {
        getDistanceStatus(distance)
    }
    
    private var isDeltaSmall: Bool {
        isDistanceDeltaSmall(distance)
    }
    
    var body: some View {
        VStack {
            CalibrationCameraView(distance: $distance)
                .overlay(alignment: .top, content: {
                    DistanceCapsule(distance: $distance)
                })
                .padding([.leading, .trailing])
                .padding(.top, 40)
                .onAppear { // disable auto lock
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear { // enable auto lock
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            Spacer()
            CalibrationInstructionView(distance: $distance)
                .onChange(of: distanceStatus) { newValue in // Haptic
                    isCalibrated = false
                    if newValue == .missing {
                        HapticManager.shared.notification(type: .error)
                    }
                    if newValue == .valid {
                        HapticManager.shared.impact(style: .heavy)
                    }
                }
                .onAppear {
                    let vi = NSLocalizedString("calibrationMissingVI", comment: "")
                    T2SManager.shared.speakSentence(vi, delay: 0.0)
                }
                .onDisappear {
                    T2SManager.shared.stopSpeaking()
                }
            Spacer()
            if distanceStatus == .valid {
                TimedButton
                    .cornerRadius(15)
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity).animation(.easeInOut), removal: .opacity.animation(.linear(duration: 0.0))))
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .bottom)
                    .onAppear {
                        timerReset()
                    }
                    .onReceive(timer) { _ in
                        if secondsSinceValid < 5 {
                            withAnimation {
                                secondsSinceValid += 1
                            }
                        } else {
                            calibrationSuccess()
                        }
                    }
                    .onTapGesture {
                        calibrationSuccess()
                    }
            }
        }
        .overlay(alignment: .top) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 50, height: 6)
        }
        .overlay(alignment: .topLeading, content: {
            Button {
                isCalibrated = false
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text(NSLocalizedString("calibrationButtonCancel", comment: ""))
                    .foregroundColor(.red)
            }

        })
        .padding()
        .onAppear {
            HapticManager.shared.notification(type: .warning)
        }
        .onChange(of: distance) { newValue in // Haptic if distance changes
            HapticManager.shared.impact(style: .soft)
        }
        .onChange(of: distanceStatus) { newValue in
            if newValue == .valid {
                SoundManager.shared.playSound(filename: "double_pop.mp3")
            }
            switch newValue {
            case .missing:
                let vi = NSLocalizedString("calibrationMissingVI", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            case .tooClose:
                let vi = NSLocalizedString("calibrationTooCloseVI", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            case .valid:
                let vi = NSLocalizedString("calibrationValidVI", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.5)
            case .tooFar:
                let vi: String = NSLocalizedString("calibrationTooFarVI", comment: "")
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            }
        }
        
    }
    
    private var TimedButton: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 0, style: .circular)
                    .fill(.mint)
                RoundedRectangle(cornerRadius: 0, style: .circular)
                    .fill(.teal)
                    .animation(timeButtonAnimation, value: secondsSinceValid)
                    .frame(width: secondsSinceValid/5.0 * geometry.size.width)
                Text("Done")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var timeButtonAnimation: Animation {
        if secondsSinceValid == 0.0 {
            return Animation.linear(duration: 0.0)
        } else {
            return Animation.linear(duration: 1.0)
        }
    }
    
    private func calibrationSuccess() {
        isCalibrated = true
        HapticManager.shared.notification(type: .success)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func timerReset() {
        secondsSinceValid = 0.0
    }
}

struct CalibrationMainView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationMainView(distance: .constant(40), isCalibrated: .constant(false))
    }
}
