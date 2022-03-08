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
                .drawingGroup()
        }
    }
    
    let opacityInTransition: AnyTransition = AnyTransition.asymmetric(insertion: .opacity.animation(.linear(duration: 0.3)), removal: .opacity.animation(.linear(duration: 0.0)))
    let scalingAnimation: Animation = Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)
    let scalingAnimationDelay: Int = 500
    
    private var instructionShortView: some View {
        Group {
            if (distanceStatus == .missing) {
                Text("Show your face")
                    .makeInstructionShort()
                    .transition(opacityInTransition)
                    .onAppear {
                        scaled = false
                    }
            }
            if (distanceStatus == .tooClose) {
                Group {
                    if isDeltaSmall {
                        Text("Just a bit further")
                            .makeInstructionShort()
                    } else {
                        Text("Too close")
                            .makeInstructionShort()
                            .scaleEffect(scaled ? 2 : 1)
                            .onAppear {
                                startScalingDelayed()
                            }
                    }
                }
                .transition(opacityInTransition)
            }
            if (distanceStatus == .valid) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70, weight: .regular, design: .rounded))
                    .foregroundColor(.green)
                    .scaleEffect(scaled ? 1.2 : 1)
                    .transition(opacityInTransition)
                    .onAppear {
                        scaled = false
                        DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(scalingAnimationDelay)) {
                            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                                scaled.toggle()
                            }
                        }
                    }
            }
            if (distanceStatus == .tooFar) {
                Group {
                    if isDeltaSmall {
                        Text("Just a bit closer")
                            .makeInstructionShort()
                    } else {
                        Text("Too far")
                            .makeInstructionShort()
                            .scaleEffect(scaled ? 0.5 : 1)
                            .onAppear {
                                startScalingDelayed()
                            }
                    }
                }
                .transition(opacityInTransition)
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
                Text("Please maintain this distance during the tests. ")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            if (distanceStatus == .tooFar) {
                Text("Your phone is too far away from your face. \nPlease move your iPhone closer. ")
                    .makeInstructionFull()
                    .padding(.top)
            }
        }
        .foregroundColor(instructionThemeColor)
        .transition(opacityInTransition)
    }
    
    private func startScalingDelayed() {
        scaled = false
        DispatchQueue.main.asyncAfter(deadline: .now()+DispatchTimeInterval.milliseconds(scalingAnimationDelay)) {
            withAnimation(scalingAnimation) {
                scaled.toggle()
            }
        }
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
    }
    
    func makeInstructionFull() -> some View {
        self.fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

struct CalibrationInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationInstructionView(distance: .constant(40))
    }
}
