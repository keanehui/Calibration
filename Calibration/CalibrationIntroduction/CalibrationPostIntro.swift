//
//  CalibrationPreIntro.swift
//  Calibration
//
//  Created by Keane Hui on 28/2/2022.
//

import SwiftUI

struct CalibrationPostIntro: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var distance: Int
    @Binding var isCalibrated: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.wave.2.fill").foregroundColor(.blue)
                Image(systemName: "checkmark").padding(.leading).foregroundColor(.green)
                Image(systemName: "iphone").foregroundColor(.gray)
                    .onTapGesture { // DEBUG ONLY
                        isCalibrated = false
                    }
            }
            .font(.system(size: 70))
            Text(NSLocalizedString("postIntroTextTop", comment: ""))
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
            Text(NSLocalizedString("postIntroTextBottom", comment: ""))
                .font(.title3)
                .multilineTextAlignment(.center)
            NavigationLink(destination: EyeTestMainView(distance: $distance, isCalibrated: $isCalibrated)) {
                Text(NSLocalizedString("postIntroButtonTop", comment: ""))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(10)
            }
            Button(action: {
                isCalibrated = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text(NSLocalizedString("postIntroButtonBottom", comment: ""))
                    .padding(.top, 5)
            }
        }
    }
}


struct CalibrationPreIntro_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationPostIntro(distance: .constant(40), isCalibrated: .constant(false))
    }
}
