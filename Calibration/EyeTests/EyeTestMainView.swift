//
//  EyeTestView.swift
//  Calibration
//
//  Created by Keane Hui on 3/3/2022.
//

import SwiftUI

struct EyeTestMainView: View {
    @Binding var distance: Int
    @Binding var isCalibrated: Bool
    @ObservedObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var eyeTestNumber: Int = 1
    @FocusState private var isFocused: Bool
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
            .onTapGesture {
                isFocused = false
            }
            .onAppear {
                let vi: String = NSLocalizedString("eyeTestQuestion", comment: "")
                T2SManager.shared.speakSentence(vi)
            }
            .onDisappear {
                T2SManager.shared.stopSpeaking()
            }
            Text(NSLocalizedString("eyeTestQuestion", comment: ""))
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
                .onTapGesture {
                    isFocused = false
                }
            HStack {
                TextField(NSLocalizedString("eyeTestPlaceHolder", comment: ""), text: $text)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .background(.bar)
                    .cornerRadius(15)
                if eyeTestNumber != 3 {
                    Button {
                        withAnimation {
                            eyeTestNumber += 1
                            text = ""
                        }
                    } label: {
                        Text("Done")
                            .fontWeight(.bold)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(15)
                            .frame(maxHeight: 40)
                    }
                }
            }
            .padding()
            Spacer()
        }
        .padding(.top, 30)
        // *** Background distance tracking below ***
        .onAppear() {
            startTracking()
        }
        .overlay(alignment: .bottom, content: {
            if !isFocused {
                AudioWaveformWithMic()
                    .edgesIgnoringSafeArea(.bottom)
                    .frame(maxHeight: 100)
            }
        })
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
                        if !isLoading {
                            DistanceCapsule(distance: $distance)
                        }
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
                appState.rootViewId = UUID()
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
        isTracking = false
        T2SManager.shared.stopSpeaking()
        SoundManager.shared.playSound(filename: "alert.mp3")
        HapticManager.shared.notification(type: .error)
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
        EyeTestMainView(distance: .constant(40), isCalibrated: .constant(true), appState: AppState())
    }
}
