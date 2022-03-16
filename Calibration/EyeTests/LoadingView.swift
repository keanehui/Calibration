//
//  LoadingView.swift
//  Calibration
//
//  Created by Keane Hui on 16/3/2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0.0)
                .fill(.clear)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            ProgressView()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
