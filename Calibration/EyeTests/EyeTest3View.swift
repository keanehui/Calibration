//
//  EyeTest3View.swift
//  Calibration
//
//  Created by Keane Hui on 4/3/2022.
//

import SwiftUI

struct EyeTest3View: View {
    @Binding var eyeTestNumber: Int
    @Binding var text: String
    
    var body: some View {
        VStack {
            EyeTestQuestion(imageName: "colorblind-test-3-16", text: $text)
                .padding()
        }
    }
}

struct EyeTest3View_Previews: PreviewProvider {
    static var previews: some View {
        EyeTest3View(eyeTestNumber: .constant(3), text: .constant(""))
    }
}
