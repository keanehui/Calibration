//
//  EyeTest2.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI
import AVFoundation

struct HomePageView: View {
    let vi: String = "Press 'Start Test' to proceed. "
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Home Page")
                .font(.largeTitle)
                .fontWeight(.bold)
            NavigationLink(destination: CalibrationIntroView()) {
                Text("Start Test")
            }
            Button {
                openSetting()
            } label: {
                Text("Settings")
            }
            Button {
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            } label: {
                Text("Play")
            }
        }
        .padding()
        .onAppear {
            
        }
    }
    
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
