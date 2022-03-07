//
//  Test.swift
//  Calibration
//
//  Created by Keane Hui on 25/2/2022.
//

import SwiftUI

struct HapticTest: View {
    var body: some View {
        HapticTest_View()
    }
}

struct HapticTest_View: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Notification success") {
                HapticManager.shared.notification(type: .success)
            }
            Button("Notification warning") {
                HapticManager.shared.notification(type: .warning)
            }
            Button("Notification error") {
                HapticManager.shared.notification(type: .error)
            }
            Divider()
            Button("Impact light") {
                HapticManager.shared.impact(style: .light)
            }
            Button("Impact heavy") {
                HapticManager.shared.impact(style: .heavy)
            }
            Button("Impact medium") {
                HapticManager.shared.impact(style: .medium)
            }
            Button("Impact rigid") {
                HapticManager.shared.impact(style: .rigid)
            }
            Button("Impact soft") {
                HapticManager.shared.impact(style: .soft)
            }
        }
    }
}

struct HapticTest_Previews: PreviewProvider {
    static var previews: some View {
        HapticTest()
    }
}
