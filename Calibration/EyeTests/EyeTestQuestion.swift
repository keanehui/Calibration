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
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            Group {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                Text("What number do you see in the image above?")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .onTapGesture {
                isFocused = false
            }
            TextField("Enter a number here", text: $text)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .background(.bar)
                .cornerRadius(15)
        }
    }
}

struct EyeTestQuestion_Previews: PreviewProvider {
    static var previews: some View {
        EyeTestQuestion(imageName: "colorblind-test-1-3", text: .constant(""))
    }
}
