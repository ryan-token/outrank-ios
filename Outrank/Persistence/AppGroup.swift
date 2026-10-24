//
//  AppGroup.swift
//  Outrank
//
//  Created by Ryan Token on 10/14/21.
//

import Foundation

/// Storage shared between the app and the widget extension.
nonisolated enum AppGroup {
    static let identifier = "group.com.ryantoken.teamrankings"

    /// Defaults both processes can read. Computed rather than stored because
    /// `UserDefaults` isn't `Sendable`; Foundation reuses the suite's storage, so this is cheap.
    static var defaults: UserDefaults? {
        UserDefaults(suiteName: identifier)
    }

    /// The team the widgets show, chosen in Settings.
    static let widgetTeamKey = "WidgetTeam"

    static let defaultWidgetTeam = "Air Force"
}
