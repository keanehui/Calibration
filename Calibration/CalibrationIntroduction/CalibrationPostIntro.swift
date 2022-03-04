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
            Text("iPhone now knows the distance between the screen and your face. Please maintain the calibrated distance. \n\nThe camera will be tracking the distance during the test, you will be notified if you are too close or too far away from the screen. ")
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.top)
            Spacer()
            NavigationLink(destination: EyeTestMainView(distance: $distance, isCalibrated: $isCalibrated)) {
                Text("Start the test")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.green)
                    .cornerRadius(10)
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Not now")
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
