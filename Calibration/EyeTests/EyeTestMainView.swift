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
    @State private var isLoading: Bool = false
    @State private var isTracking: Bool = false
    @State private var isPresentingCalibration: Bool = false
    @State private var isPresentingAlert: Bool = false
    // *** distance tracking ***
    
    private var distanceStatus: DistanceStatus {
        getDistanceStatus(distance)
    }
    
    var body: some View {
        VStack {
            Group {
                if eyeTestNumber == 1 {
                    EyeTest1View(eyeTestNumber: $eyeTestNumber, text: $text)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).animation(.easeInOut), removal: .move(edge: .leading)).animation(.easeInOut))
                } else if eyeTestNumber == 2 {
                    EyeTest2View(eyeTestNumber: $eyeTestNumber, text: $text)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).animation(.easeInOut), removal: .move(edge: .leading)).animation(.easeInOut))
                } else if eyeTestNumber == 3 {
                    EyeTest3View(eyeTestNumber: $eyeTestNumber, text: $text)
                        .transition(.asymmetric(insertion: .move(edge: .trailing).animation(.easeInOut), removal: .move(edge: .leading)).animation(.easeInOut))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                let vi: String = NSLocalizedString("eyeTestQuestion", comment: "")
                T2SManager.shared.speakSentence(vi)
            }
            .onDisappear {
                T2SManager.shared.stopSpeaking()
            }
            if eyeTestNumber != 3 {
                Button {
                    withAnimation {
                        eyeTestNumber += 1
                        text = ""
                    }
                } label: {
                    Text("Done")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(15)
                }
            }
        }
        // *** Background distance tracking below ***
        .onAppear() {
            startTracking()
        }
        .overlay {
            if isLoading {
                LoadingView()
                    .onDisappear() {
                        if distanceStatus != .valid {
                            presentAlert()
                        }
                    }
            }
        }
        .overlay {
            if isTracking {
                CalibrationCameraView(distance: $distance)
                    .frame(maxHeight: .infinity)
                    .opacity(0.0)
                    .onChange(of: distanceStatus) { newValue in
                        if !isLoading && newValue != .valid {
                            presentAlert()
                        }
                    }
                    .onAppear {
                        if isCalibrated == false {
                            presentAlert()
                        }
                    }
                    .overlay(alignment: .top, content: {
                        DistanceCapsule(distance: $distance).zIndex(-1)
                    })
            }
        }
        .sheet(isPresented: $isPresentingCalibration) {
            CalibrationMainView(distance: $distance, isCalibrated: $isCalibrated)
                .onDisappear {
                    startTracking()
                }
        }
        .alert(
            Text(NSLocalizedString("alertTitle", comment: "")), isPresented: $isPresentingAlert
        ) {
            Button(role: .cancel) {
                isCalibrated = false
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text(NSLocalizedString("alertButton1", comment: ""))
            }
            Button() {
                isPresentingCalibration = true
            } label: {
                Text(NSLocalizedString("alertButton2", comment: ""))
            }
        } message: {
            Text(NSLocalizedString("alertText", comment: ""))
        }
    }
    
    private func presentAlert() {
        print("alert status: \(distanceStatus)")
        isCalibrated = false
        isPresentingAlert = true
        HapticManager.shared.notification(type: .error)
        isTracking = false
    }
    
    private func startTracking() {
        isLoading = true
        isTracking = true
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            isLoading = false
        }
    }
}

struct EyeTestView_Previews: PreviewProvider {
    static var previews: some View {
        EyeTestMainView(distance: .constant(40), isCalibrated: .constant(true))
    }
}
