//
//  SoundManager.swift
//  Calibration
//
//  Created by Keane Hui on 27/2/2022.
//

import Foundation
import AVKit

class SoundManager {
    static let shared = SoundManager(enabled: SOUND_ENABLED)
    private var enabled: Bool
    
    init(enabled: Bool = true) {
        self.enabled = enabled
    }
    
    func setEnable() {
        enabled = true
    }
    
    func setDisable() {
        enabled = false
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
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

