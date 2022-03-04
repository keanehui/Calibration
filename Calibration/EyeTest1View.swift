//
//  CalibrationSuccessView.swift
//  Calibration
//
//  Created by Keane Hui on 5/2/2022.
//

import SwiftUI

struct EyeTest1View: View {
    @Binding var eyeTestNumber: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Text("EyeTest 1")
                .font(.largeTitle)
                .fontWeight(.bold)
            Button {
                eyeTestNumber += 1
            } label: {
                Text("To EyeTest 2")
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EyeTest1View_Previews: PreviewProvider {
    static var previews: some View {
        EyeTest1View(eyeTestNumber: .constant(1))
    }
}
