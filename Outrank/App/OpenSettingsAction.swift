//
//  OpenSettingsAction.swift
//  Outrank
//

import SwiftUI

/// Switches the window to the Settings tab and opens one of its pages. Read it from
/// the environment and call it like a function: `openSettings(.favorites)`.
struct OpenSettingsAction {
    let handler: (SettingsDetail) -> Void

    func callAsFunction(_ detail: SettingsDetail) {
        handler(detail)
    }
}

extension EnvironmentValues {
    @Entry var openSettings = OpenSettingsAction { _ in }
}
