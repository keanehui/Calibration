//
//  SoundManager.swift
//  Calibration
//
//  Created by Keane Hui on 27/2/2022.
//

import Foundation
import AVKit

class SoundManager {
    static let shared = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(filename: String) {
        let filenameArr: [String] = filename.components(separatedBy: ".")
        guard let url = Bundle.main.url(forResource: filenameArr[0], withExtension: filenameArr[1])
        else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}

