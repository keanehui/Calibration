//
//  EyeTest2.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI
import AVFoundation

struct HomePageView: View {
    let vi: String = NSLocalizedString("homeVI", comment: "")
    
    var body: some View {
        VStack(spacing: 30) {
            Text(NSLocalizedString("homePageText", comment: ""))
                .font(.largeTitle)
                .fontWeight(.bold)
            NavigationLink(destination: CalibrationIntroView()) {
                Text(NSLocalizedString("homeStartButton", comment: ""))
            }
            Button {
                openSetting()
            } label: {
                Text(NSLocalizedString("homeSettingButton", comment: ""))
            }
            Button {
                T2SManager.shared.speakSentence(vi, delay: 0.0)
            } label: {
                Text(NSLocalizedString("homePlayButton", comment: ""))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top, content: {
            Text(Bundle.main.preferredLocalizations.first!)
        })
    }
    
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
