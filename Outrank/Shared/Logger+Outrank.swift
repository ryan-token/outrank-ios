//
//  Logger+Outrank.swift
//  Outrank
//

import OSLog

nonisolated extension Logger {
    /// A logger under the app's subsystem, shared by the app and the widget extension so
    /// Console can filter both by one name.
    init(category: String) {
        self.init(subsystem: "com.ryantoken.Outrank", category: category)
    }
}
