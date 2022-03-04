//
//  EyeTestView.swift
//  Calibration
//
//  Created by Keane Hui on 3/3/2022.
//

import SwiftUI

struct EyeTestMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var distance: Int
    @Binding var isCalibrated: Bool
    @State private var eyeTestNumber: Int = 1
    
    @State private var isTracking: Bool = true
    @State private var isPresentingSheet: Bool = false
    @State private var isPresentingAlert: Bool = false
    @State private var shouldEndTest: Bool = false
    
    private var distanceStatus: DistanceStatus {
        getDistanceStatus(distance)
    }
    
    var body: some View {
        ZStack {
            Group {
                if eyeTestNumber == 1 {
                    EyeTest1View(eyeTestNumber: $eyeTestNumber)
                } else if eyeTestNumber == 2 {
                    EyeTest2View(eyeTestNumber: $eyeTestNumber)
                }
            }
        }
        
        // Background distance tracking below
        .overlay(alignment: .top, content: {
            DistanceCapsule(distance: $distance)
        })
        .onChange(of: shouldEndTest, perform: { newValue in
            if newValue == true {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .overlay {
            if isTracking {
                CalibrationCameraView(distance: $distance)
                    .opacity(0.0)
                    .onChange(of: distanceStatus) { newValue in
                        if newValue != .valid {
                            isCalibrated = false
                            isPresentingAlert = true
                            HapticManager.shared.notification(type: .error)
                            isTracking = false
                        }
                    }
                    .onAppear {
                        if isCalibrated == false {
                            isPresentingAlert = true
                            HapticManager.shared.notification(type: .error)
                            isTracking = false
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingSheet) {
            CalibrationMainView(distance: $distance, isCalibrated: $isCalibrated)
                .onDisappear {
                    isTracking = true
                }
        }
        .alert(
            Text("Calibration Required"), isPresented: $isPresentingAlert
        ) {
            Button(role: .cancel) {
                shouldEndTest.toggle()
            } label: {
                Text("End test")
            }
            Button() {
                isPresentingSheet = true
            } label: {
                Text("Calibrate")
            }
        } message: {
            Text("You are not within the appropriate distance from your iPhone's screen. Complete another calibration to continue. ")
        }
    }
}

struct EyeTestView_Previews: PreviewProvider {
    static var previews: some View {
        EyeTestMainView(distance: .constant(40), isCalibrated: .constant(true))
    }
}
