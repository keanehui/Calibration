//
//  SoundManager.swift
//  Calibration
//
//  Created by Keane Hui on 27/2/2022.
//

import Foundation
import AVKit
import SwiftUI

class SoundManager: ObservableObject {
    static var shared = SoundManager()
    var enabled: Bool
    
    init() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(ENABLE_SOUND_INIT, forKey: "user_sound_enabled")
        self.enabled = ENABLE_SOUND_INIT
    }
    
    var player: AVAudioPlayer?
    
    func playSound(filename: String) {
        if !enabled {
            return
        }
        let filenameArr: [String] = filename.components(separatedBy: ".")
        guard let url = Bundle.main.url(forResource: filenameArr[0], withExtension: filenameArr[1]) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("played: \(filename)")
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

