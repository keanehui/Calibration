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
                CalibrationPreIntro(isPresenting: $isPresenting)
            } else {
                CalibrationPostIntro(distance: $distance, isCalibrated: $isCalibrated)
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


