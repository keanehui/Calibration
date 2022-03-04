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
//    @State private var isTimerRunning: Bool = false
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
                .onAppear {
                    secondsSinceValid = 0.0
                    timer.upstream.connect().cancel()
                    isCalibrated = false
                }
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
                .offset(x: 0, y: distanceStatus == .valid ? -10 : 0)
                .onChange(of: distance, perform: { newValue in // Haptic if distance changes
                    HapticManager.shared.impact(style: .soft)
                })
                .onChange(of: distanceStatus) { newValue in // Haptic
                    isCalibrated = false
                    secondsSinceValid = 0.0
                    if newValue == .missing {
                        HapticManager.shared.notification(type: .error)
                    }
                    if newValue == .valid {
                        HapticManager.shared.impact(style: .heavy)
                    }
                }
            Spacer()
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
                .onAppear {
                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                }
                .onDisappear {
                    timer.upstream.connect().cancel()
                }
                .onReceive(timer) { _ in
                    if secondsSinceValid < 5 {
                        withAnimation {
                            secondsSinceValid += 1
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(500)) {
                            isCalibrated = true
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .onTapGesture {
                    isCalibrated = true
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
    }
}

struct CalibrationMainView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationMainView(distance: .constant(0), isCalibrated: .constant(false))
    }
}
