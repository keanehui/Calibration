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
            Capsule()
                .fill(Color.secondary)
                .frame(width: 50, height: 6)
            CalibrationCameraView(distance: $distance)
                .overlay(alignment: .top, content: {
                    DistanceCapsule(distance: $distance)
                })
                .padding([.leading, .trailing])
                .padding(.top, 30)
                .onAppear { // disable auto lock
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear { // enable auto lock
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            Spacer()
            CalibrationInstructionView(distance: $distance)
                .offset(x: 0, y: distanceStatus == .valid ? -30 : 0)
                .onChange(of: distanceStatus) { newValue in // Haptic
                    isCalibrated = false
                    if newValue == .missing {
                        HapticManager.shared.notification(type: .error)
                    }
                    if newValue == .valid {
                        HapticManager.shared.impact(style: .heavy)
                    }
                }
            Spacer()
        }
        .onAppear {
            HapticManager.shared.notification(type: .warning)
        }
        .onChange(of: distance) { newValue in // Haptic if distance changes
            HapticManager.shared.impact(style: .soft)
        }
        .onChange(of: distanceStatus) { newValue in
            if newValue == .valid {
                SoundManager.shared.playSound(filename: "pop.mp3")
            }
            switch newValue {
            case .missing:
                let vi: String = "Please show your face in front of the camera. "
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            case .tooClose:
                let vi: String = "Your iPhone is too close! Move it away. "
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            case .valid:
                let vi: String = "Perfect! Please maintain this distance during the tests. "
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            case .tooFar:
                let vi: String = "Your iPhone is too far away! Move it closer. "
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            }
        }
        .overlay(alignment: .topLeading, content: {
            Button {
                isCalibrated = false
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
                    .foregroundColor(.red)
            }

        })
        .overlay(alignment: .bottom) { // TimedButton
            if distanceStatus == .valid {
                TimedButton
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .cornerRadius(15)
                    .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity).animation(.easeInOut), removal: .opacity.animation(.linear(duration: 0.0))))
                    .zIndex(3.0)
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
        .padding()
    }
    
    private var TimedButton: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 0, style: .circular)
                    .fill(.teal)
                RoundedRectangle(cornerRadius: 0, style: .circular)
                    .fill(.blue)
                    .animation(.linear(duration: 1), value: secondsSinceValid)
                    .frame(width: secondsSinceValid/5.0 * geometry.size.width)
                Text("Done")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
        }
        .drawingGroup()
    }
    
    private func calibrationSuccess() {
        isCalibrated = true
        HapticManager.shared.notification(type: .success)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func timerReset() {
        secondsSinceValid = 0.0
        print("timer is reset")
    }
}

struct CalibrationMainView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationMainView(distance: .constant(0), isCalibrated: .constant(false))
    }
}
