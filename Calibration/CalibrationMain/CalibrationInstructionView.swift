//
//  CalibrationInstructionView.swift
//  Calibration
//
//  Created by Keane Hui on 23/2/2022.
//

import SwiftUI
import AVFoundation

struct CalibrationInstructionView: View {
    @Binding var distance: Int
    @State private var scaled: Bool = false
    @Namespace var namespace
    
    private var distanceStatus: DistanceStatus {
        getDistanceStatus(distance)
    }
    
    private var isDeltaSmall: Bool {
        isDistanceDeltaSmall(distance)
    }
    
    var body: some View {
        VStack {
            instructionShortView
            instructionFullView
        }
        .offset(x: 0, y: distanceStatus == .valid ? -20 : 0)
    }
    
    let commonAnimation: Animation = Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
    
    private var instructionShortView: some View {
        Group {
            if (distanceStatus == .missing) {
                Text("Show your face")
                    .makeInstructionShort()
                    .onAppear {
                        scaled = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(200)) {
                            withAnimation(commonAnimation) {
                                scaled.toggle()
                            }
                        }
                    }
            }
            if (distanceStatus == .tooClose) {
                if isDeltaSmall {
                    Text("Just a bit further")
                        .makeInstructionShort()
                } else {
                    Text("Too close")
                        .makeInstructionShort()
                        .scaleEffect(scaled ? 2 : 1)
                        .onAppear {
                            scaled = false
                            DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(200)) {
                                withAnimation(commonAnimation) {
                                    scaled.toggle()
                                }
                            }
                        }
                }
                
            }
            if (distanceStatus == .valid) {
                Group {
                    if scaled {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 70, weight: .regular, design: .rounded))
                            .padding(.bottom)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 70, weight: .regular, design: .rounded))
                            .padding(.bottom)
                    }
                }
                .onAppear {
                    do {
                        try AVAudioSession.sharedInstance().setActive(true)
                    } catch let error {
                        print("Setting AVAudioSession active failed. \(error.localizedDescription)")
                    }
                    SoundManager.shared.playSound(filename: "pop.mp3")
                    scaled = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(200)) {
                        withAnimation(.easeInOut(duration: 2)) { // Sound if valid
                            scaled.toggle()
                        }
                    }
                }
            }
            if (distanceStatus == .tooFar) {
                if isDeltaSmall {
                    Text("Just a bit closer")
                        .makeInstructionShort()
                } else {
                    Text("Too far")
                        .makeInstructionShort()
                        .scaleEffect(scaled ? 0.5 : 1)
                        .onAppear {
                            scaled = false
                            DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(200)) {
                                withAnimation(commonAnimation) {
                                    scaled.toggle()
                                }
                            }
                        }
                }
            }
        }
            .foregroundColor(instructionThemeColor)
    }
    
    private var instructionFullView: some View {
        Group {
            if (distanceStatus == .missing) {
                (Text("Please show your face in the ") +
                 Text("square").foregroundColor(.blue) +
                 Text(". "))
                    .makeInstructionFull()
                    .padding(.top)
            }
            if (distanceStatus == .tooClose) {
                Text("Your phone is too close from your face. \nPlease move your iPhone away. ")
                    .makeInstructionFull()
                    .padding(.top)
            }
            if (distanceStatus == .valid) {
                Text("Please maintain this distance during the test. ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            if (distanceStatus == .tooFar) {
                Text("Your phone is too far away from your face. \nPlease move your iPhone closer. ")
                    .makeInstructionFull()
                    .padding(.top)
            }
        }
            .foregroundColor(instructionThemeColor)
    }
}

extension CalibrationInstructionView {
    private var instructionThemeColor: Color {
        switch distanceStatus {
        case .missing:
            return .gray
        case .tooClose, .tooFar:
            return .orange
        case .valid:
            return .green
        }
    }
}

extension Text {
    func makeInstructionShort() -> some View {
        self.fontWeight(Font.Weight.bold)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .transition(AnyTransition.asymmetric(insertion: .opacity.animation(.linear(duration: 0.5)), removal: .opacity.animation(.linear(duration: 0.0))))
    }
    
    func makeInstructionFull() -> some View {
        self.fontWeight(.bold)
            .multilineTextAlignment(.center)
            .transition(AnyTransition.asymmetric(insertion: .opacity.animation(.linear(duration: 0.5)), removal: .opacity.animation(.linear(duration: 0.0))))
    }
}

struct CalibrationInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationInstructionView(distance: .constant(40))
    }
}
