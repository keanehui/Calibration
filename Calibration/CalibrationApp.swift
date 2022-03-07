//
//  CalibrationApp.swift
//  Calibration
//
//  Created by Keane Hui on 4/2/2022.
//

import SwiftUI
import AVFoundation

@main
struct CalibrationApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomePageView()
            }
            .onChange(of: scenePhase) { newValue in
                updateManagerSettings()
            }
        }
    }
    
    init() {
        SoundManager.shared.playSound(filename: "silence.mp3")
    }
    
//    private func setAudioSessionCategory(category: AVAudioSession.Category) {
//        do {
//            let audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(category)
//        } catch let error {
//            print("Setting category to AVAudioSessionCategoryPlayback failed. \(error.localizedDescription)")
//        }
//    }
    
    
}

func getDistanceStatus(_ distance: Int) -> DistanceStatus {
    switch distance {
    case 0:
        return .missing
    case 1...(RANGE_L-1):
        return .tooClose
    case RANGE_L...RANGE_R:
        return .valid
    case (RANGE_R+1)...:
        return .tooFar
    default:
        return .missing
    }
}

func getDistanceDelta(_ distance: Int) -> Int {
    if distance >= RANGE_L && distance <= RANGE_R {
        return 0
    } else if distance < RANGE_L {
        return distance - RANGE_L
    } else if distance > RANGE_R {
        return distance - RANGE_R
    } else {
        return 0
    }
}

func isDistanceDeltaSmall(_ distance: Int) -> Bool {
    return abs(getDistanceDelta(distance)) <= WARNING_ZONE_OUT
}

func getDistanceColor(_ distance: Int) -> Color {
    if distance == 0 {
        return Color.blue
    }
    if distance < RANGE_L || distance > RANGE_R {
        let delta: Int = min(abs(distance-RANGE_L), abs(distance-RANGE_R))
        if delta < WARNING_ZONE_OUT {
            return Color.orange
        } else {
            return Color.red
        }
    }
    if distance >= RANGE_L && distance <= RANGE_R {
        let delta: Int = min(abs(distance-RANGE_L), abs(distance-RANGE_R))
        if delta > WARNING_ZONE_IN {
            return Color.green
        } else {
            return Color.yellow
        }
    }
    return Color.blue
}

func openSetting() {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
}

func updateManagerSettings() {
    let userDefaults = UserDefaults.standard
    HapticManager.shared.enabled = userDefaults.bool(forKey: "user_haptic_enabled")
    SoundManager.shared.enabled = userDefaults.bool(forKey: "user_sound_enabled")
    T2SManager.shared.enabled = userDefaults.bool(forKey: "user_voice_instruction_enabled")
    T2SManager.shared.rate = userDefaults.float(forKey: "user_voice_instruction_rate")
    print("\(HapticManager.shared.enabled) \(SoundManager.shared.enabled) \(T2SManager.shared.enabled) \(T2SManager.shared.rate!)")
}

enum DistanceStatus: String {
    case missing
    case tooClose
    case valid
    case tooFar
}
