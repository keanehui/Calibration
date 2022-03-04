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
    
    init() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.ambient)
        } catch let error {
            print("Setting category to AVAudioSessionCategoryPlayback failed. \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomePageView()
            }
//            Test()
        }
    }
}

let RANGE_L = 40
let RANGE_R = 50
let WARNING_ZONE_IN = 3
let WARNING_ZONE_OUT = 5

func getDistanceStatus(_ distance: Int) -> DistanceStatus {
    switch distance {
    case ...0:
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
        if delta > WARNING_ZONE_OUT {
            return Color.red
        } else {
            return Color.orange
        }
    }
    if (distance >= RANGE_L && distance <= RANGE_R) && (abs(distance-RANGE_L)<=WARNING_ZONE_IN || abs(distance-RANGE_R)<=WARNING_ZONE_IN) {
        return Color.yellow
    } else {
        return Color.green
    }
}

enum DistanceStatus: String {
    case missing
    case tooClose
    case valid
    case tooFar
}
