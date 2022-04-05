//
//  CalibrationPostIntro.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI

struct CalibrationPreIntro: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresenting: Bool
    @Binding var isListeningVI: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.wave.2.fill").foregroundColor(.blue)
                Image(systemName: "arrow.left.and.right").padding(.leading).foregroundColor(.orange)
                Image(systemName: "iphone").foregroundColor(.gray)
            }
            .font(.system(size: 70))
            Text(NSLocalizedString("preIntroTextTop", comment: ""))
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.top)
            Spacer()
            Button {
                openSetting()
            } label: {
                Text(NSLocalizedString("turnOnVIInSetting", comment: ""))
            }
            .disabled(T2SManager.shared.enabled)
            Spacer()
            Text(NSLocalizedString("preIntroTextBottom", comment: ""))
                .font(.title3)
            Button {
                isPresenting = true
            } label: {
                Text(NSLocalizedString("preIntroButtonTop", comment: ""))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
                    .overlay(alignment: .trailing) {
                        if isListeningVI {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.red)
                                .padding(5)
                                .background(.ultraThickMaterial, in: Circle())
                                .offset(x: -10, y: 0)
                                .transition(.opacity.animation(.easeInOut))
                        }
                    }
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text(NSLocalizedString("preIntroButtonBottom", comment: ""))
                    .padding([.top, .leading, .trailing])
            }
        }
    }
}


struct CalibrationPostIntro_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationPreIntro(isPresenting: .constant(false), isListeningVI: .constant(true))
    }
}
