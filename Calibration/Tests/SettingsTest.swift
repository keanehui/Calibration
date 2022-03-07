//
//  Test.swift
//  Calibration
//
//  Created by Keane Hui on 1/3/2022.
//

import SwiftUI

struct SettingsTest: View {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack(spacing: 30) {
            Button {
                openSetting()
            } label: {
                Text("Button")
            }
            
            if HapticManager.shared.enabled {
                Text("Haptic: true")
            } else {
                Text("Haptic: false")
            }
            if SoundManager.shared.enabled {
                Text("Sound: true")
            } else {
                Text("Sound: false")
            }
        }
        .onChange(of: scenePhase) { newValue in
            let userDefaults = UserDefaults.standard
            HapticManager.shared.enabled = userDefaults.bool(forKey: "user_haptic_enabled")
            SoundManager.shared.enabled = userDefaults.bool(forKey: "user_sound_enabled")
        }
        
        
        

        
        
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTest()
    }
}
