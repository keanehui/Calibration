//
//  Test.swift
//  Calibration
//
//  Created by Keane Hui on 1/3/2022.
//

import SwiftUI

struct Test: View {
    @State private var portion: CGFloat = 0.1
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 0, style: .circular)
                    .fill(.teal)
                RoundedRectangle(cornerRadius: 0, style: .circular)
                    .fill(.green)
                    .animation(.linear, value: portion)
                    .frame(width: portion / 5.0 * geometry.size.width)
                    .onReceive(timer) { _ in
                        let _ = print("tick \(portion)")
                        withAnimation {
                            portion += 1
                        }
                    }
                Text("Done")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 60)
        .cornerRadius(15)
        .padding()
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
