//
//  CalibrationCameraView.swift
//  Calibration
//
//  Created by Keane Hui on 4/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var distance: Int
    @Binding var isCalibrated: Bool
    @State private var secondsSinceValid: CGFloat = 0.0
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
            timer.upstream.connect().cancel()
            isCalibrated = false
            HapticManager.shared.notification(type: .warning)
        }
        .onChange(of: distance) { newValue in // Haptic if distance changes
            HapticManager.shared.impact(style: .soft)
        }
        .onChange(of: distanceStatus) { newValue in
            if newValue == .valid {
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch let error {
                    print("Setting AVAudioSession active failed. \(error.localizedDescription)")
                }
                SoundManager.shared.playSound(filename: "pop.mp3")
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
                    .transition(.offset(x: 0, y: 100).animation(.spring()))
                    .zIndex(3.0)
                    .onAppear {
                        secondsSinceValid = 0.0
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    }
                    .onDisappear {
                        secondsSinceValid = 0.0
                        timer.upstream.connect().cancel()
                    }
                    .onReceive(timer) { _ in
                        if secondsSinceValid < 5 {
                            withAnimation {
                                secondsSinceValid += 1
                            }
                        } else {
                            isCalibrated = true
                            HapticManager.shared.notification(type: .success)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .onTapGesture {
                        isCalibrated = true
                        HapticManager.shared.notification(type: .success)
                        self.presentationMode.wrappedValue.dismiss()
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
}

struct CalibrationMainView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationMainView(distance: .constant(0), isCalibrated: .constant(false))
    }
}
