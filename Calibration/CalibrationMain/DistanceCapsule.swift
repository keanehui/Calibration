//
//  DistanceCapsule.swift
//  Calibration
//
//  Created by Keane Hui on 3/3/2022.
//

import SwiftUI

struct DistanceCapsule: View {
    @Binding var distance: Int
    
    private var distanceColor: Color {
        getDistanceColor(distance)
    }
    
    var body: some View {
        ZStack {
            Capsule(style: .circular)
            .opacity(0.7)
            .foregroundColor(distanceColor)
            .background(.ultraThinMaterial)
            .frame(width: 90, height: 30)
            .cornerRadius(15)
            .animation(.linear, value: distanceColor)
            Text("Distance: \(distance)")
                .font(.caption)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding()
        }
    }
}

struct DistanceCapsule_Previews: PreviewProvider {
    static var previews: some View {
        DistanceCapsule(distance: .constant(40))
    }
}
