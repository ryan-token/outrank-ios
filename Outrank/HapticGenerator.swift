//
//  HapticGenerator.swift
//  Outrank
//
//  Created by Ryan Token on 10/18/21.
//

import SwiftUI

enum HapticGenerator {
    static func playSuccessHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func playWarningHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    static func playErrorHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
