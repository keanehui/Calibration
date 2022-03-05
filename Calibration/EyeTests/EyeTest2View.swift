//
//  EyeTest2View.swift
//  Calibration
//
//  Created by Keane Hui on 1/3/2022.
//

import SwiftUI

struct EyeTest2View: View {
    @Binding var eyeTestNumber: Int
    @Binding var text: String
    
    var body: some View {
        VStack {
            EyeTestQuestion(imageName: "colorblind-test-1-29", text: $text)
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

struct EyeTest2View_Previews: PreviewProvider {
    static var previews: some View {
        EyeTest2View(eyeTestNumber: .constant(2), text: .constant(""))
    }
}
