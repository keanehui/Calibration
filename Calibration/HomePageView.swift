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
    
    @State private var text: String = ""
    @FocusState private var focus: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text(NSLocalizedString("homePageText", comment: ""))
                .font(.largeTitle)
                .fontWeight(.bold)
                .onTapGesture {
                    focus.toggle()
                }
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
            VStack {
                TextField("Speech Recognizer", text: $text)
                    .frame(maxWidth: .infinity, maxHeight: 70)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .focused($focus)
                HStack(spacing: 80) {
                    Button {
                        
                    } label: {
                        Text("Speak")
                    }
                    Button {
                        
                    } label: {
                        Text("Stop")
                    }
                    Button {
                        text = ""
                    } label: {
                        Text("Reset")
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top, content: {
            VStack {
                Text(Bundle.main.preferredLocalizations.first!)
                Text("auth: \(S2TManager.shared.authorized.description)")
            }
        })
    }
    
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
