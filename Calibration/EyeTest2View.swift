//
//  EyeTest2View.swift
//  Calibration
//
//  Created by Keane Hui on 1/3/2022.
//

import SwiftUI

struct EyeTest2View: View {
    @Binding var eyeTestNumber: Int
    
    var body: some View {
        VStack {
            Text("EyeTest 2")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
    }
}

struct EyeTest2View_Previews: PreviewProvider {
    static var previews: some View {
        EyeTest2View(eyeTestNumber: .constant(2))
    }
}
