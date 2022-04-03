//
//  EyeTestQuestion.swift
//  Calibration
//
//  Created by Keane Hui on 4/3/2022.
//

import SwiftUI

struct EyeTestQuestion: View {
    var imageName: String
    @Binding var text: String

    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
    }
}

struct EyeTestQuestion_Previews: PreviewProvider {
    static var previews: some View {
        EyeTestQuestion(imageName: "colorblind-test-1-3", text: .constant(""))
    }
}
