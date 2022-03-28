//
//  SpeechRecognizer.swift
//  Calibration
//
//  Created by Keane Hui on 28/3/2022.
//

import Foundation
import AVFoundation
import Speech
import SwiftUI

class S2TManager: ObservableObject {
    static let shared = S2TManager()
    @Published var authorized: Bool
    
    init() {
        self.authorized = false
    }
    
    func askForAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
                case .authorized:
                self.authorized = true
                print("auth set true")
                default:
                self.authorized = false
                print("auth set false")
            }
        }
    }
}
