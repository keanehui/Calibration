//
//  ContentView.swift
//  Calibration
//
//  Created by Keane Hui on 4/2/2022.
//

import SwiftUI

struct CalibrationIntroView: View {
    @State private var distance: Int = 0
    @State private var isCalibrated: Bool = false
    
    @State private var isPresenting: Bool = false
    
    var body: some View {
        VStack {
            if (!isCalibrated) {
                let vi: String = "iPhone needs to know the distance between the screen and your face before the eye tests by doing a simple calibration. Do you want to continue to the calibration? "
                CalibrationPreIntro(isPresenting: $isPresenting)
                    .onAppear {
                        T2SManager.shared.speakSentence(vi)
                    }
                    .onDisappear {
                        T2SManager.shared.stopSpeaking()
                    }
            } else {
                let vi: String = "iPhone now knows the distance between the screen and your face. Please maintain the distance during the whole test. \n\nThe camera will be tracking the distance and you will be notified if you are too close or too far away from the screen. Do you want to continue to the eye tests? "
                CalibrationPostIntro(distance: $distance, isCalibrated: $isCalibrated)
                    .onAppear {
                        T2SManager.shared.speakSentence(vi)
                    }
                    .onDisappear {
                        T2SManager.shared.stopSpeaking()
                    }
            }
        }
        .padding()
        .navigationTitle("Calibration")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPresenting) {
            CalibrationMainView(distance: $distance, isCalibrated: $isCalibrated)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationIntroView()
    }
}


