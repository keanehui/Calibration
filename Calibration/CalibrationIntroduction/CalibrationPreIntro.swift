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
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "person.wave.2.fill").foregroundColor(.blue)
                Image(systemName: "arrow.left.and.right").padding(.leading).foregroundColor(.orange)
                Image(systemName: "iphone").foregroundColor(.gray)
            }
            .font(.system(size: 70))
            Text("iPhone needs to know the distance between the screen and your face before the eye tests by doing a simple calibration. ")
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.top)
            Spacer()
            Text("Continue to the calibration? ")
                .font(.title3)
            Button {
                isPresenting = true
            } label: {
                Text("Yes")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.orange)
                    .cornerRadius(10)
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("No")
                    .padding(.top, 5)
            }
        }
    }
}


struct CalibrationPostIntro_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationPreIntro(isPresenting: .constant(false))
    }
}
