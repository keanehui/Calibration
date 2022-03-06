//
//  Test.swift
//  Calibration
//
//  Created by Keane Hui on 1/3/2022.
//

import SwiftUI

struct Test: View {
    
    @State private var isPresenting: Bool = true
    
    var body: some View {
        
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.yellow)
                .ignoresSafeArea()
                .zIndex(1.0)
            Button {
                withAnimation {
                    isPresenting.toggle()
                }
            } label: {
                Text("Button")
                    .padding()
                    .background(.white)
            }
            .zIndex(1.0)

            
            if isPresenting {
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(.orange)
                    .offset(x: 0, y: 300)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: isPresenting)
                    .zIndex(2.0)
            }
            
            
            
        }
        
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
