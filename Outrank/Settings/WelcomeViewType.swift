//
//  WelcomeViewType.swift
//  Outrank
//

import Foundation

enum WelcomeViewType {
    case rankings
    case settings

    var prompt: LocalizedStringResource {
        switch self {
        case .rankings: "Select a stat from the sidebar to see how every team ranks in it."
        case .settings: "Select a setting from the sidebar."
        }
    }

    /// Matches the tab's own symbol.
    var systemImage: String {
        switch self {
        case .rankings: "list.bullet.rectangle.portrait"
        case .settings: "gear"
        }
    }
}
