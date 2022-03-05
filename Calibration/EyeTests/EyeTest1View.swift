//
//  CalibrationSuccessView.swift
//  Calibration
//
//  Created by Keane Hui on 5/2/2022.
//

import SwiftUI

struct EyeTest1View: View {
    @Binding var eyeTestNumber: Int
    @Binding var text: String
    

    
    var body: some View {
        VStack {
            EyeTestQuestion(imageName: "colorblind-test-1-3", text: $text)
                .padding()
            Button {
                eyeTestNumber += 1
                text = ""
            } label: {
                Text("Done")
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(15)
            }
        }
    }
}

struct EyeTest1View_Previews: PreviewProvider {
    static var previews: some View {
        EyeTest1View(eyeTestNumber: .constant(1), text: .constant(""))
    }
}
