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
    @State private var text: String = ""
    
    // *** distance tracking ***
    @State private var trackingEnabled: Bool = false
    @State private var isTracking: Bool = true
    @State private var isPresentingSheet: Bool = false
    @State private var isPresentingAlert: Bool = false
    @State private var shouldEndTest: Bool = false
    // *** distance tracking ***
    
    private var distanceStatus: DistanceStatus {
        getDistanceStatus(distance)
    }
    
    var body: some View {
        VStack {
            Group {
                if eyeTestNumber == 1 {
                    EyeTest1View(eyeTestNumber: $eyeTestNumber, text: $text)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).animation(.easeInOut), removal: .move(edge: .leading)).animation(.easeInOut)) // BUG
                } else if eyeTestNumber == 2 {
                    EyeTest2View(eyeTestNumber: $eyeTestNumber, text: $text)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).animation(.easeInOut), removal: .move(edge: .leading)).animation(.easeInOut))
                } else if eyeTestNumber == 3 {
                    EyeTest3View(eyeTestNumber: $eyeTestNumber, text: $text)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).animation(.easeInOut), removal: .move(edge: .leading)).animation(.easeInOut))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            if eyeTestNumber != 3 {
                Button {
                    withAnimation {
                        eyeTestNumber += 1
                        text = ""
                    }
                } label: {
                    Text("Done")
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(15)
                }
            }
        }
        
        // *** Background distance tracking below ***
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
                        if trackingEnabled && newValue != .valid {
                            isCalibrated = false
                            isPresentingAlert = true
                            HapticManager.shared.notification(type: .error)
                            isTracking = false
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                            trackingEnabled = true
                        }
                        if isCalibrated == false {
                            isPresentingAlert = true
                            HapticManager.shared.notification(type: .error)
                            isTracking = false
                        }
                    }
                    .onDisappear {
                        trackingEnabled = false
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
