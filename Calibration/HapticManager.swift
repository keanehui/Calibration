//
//  HapticManager.swift
//  Calibration
//
//  Created by Keane Hui on 25/2/2022.
//

import Foundation
import UIKit

class HapticManager {
    static let shared = HapticManager(enabled: HAPTIC_ENABLED)
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
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        if !enabled {
            return
        }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        if !enabled {
            return
        }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
