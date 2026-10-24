//
//  ScreenshotMode.swift
//  Outrank
//

#if DEBUG
import Foundation
import OSLog

/// App Store screenshot support, turned on with the `-ScreenshotMode` launch argument.
/// It loads frozen rankings instead of calling the API, uses in-memory favorites instead
/// of the user's CloudKit store, and skips the review prompt.
///
/// Teams come from the existing defaults keys, passed as launch arguments, which override
/// stored values without replacing them: `-CurrentTeam Tulsa`, `-TeamOne Tulsa`,
/// `-TeamTwo SMU`. These open each screen directly:
/// - `-ScreenshotTab compare`: an ``AppTab`` raw value.
/// - `-ScreenshotStat TurnoverMargin`: the stat to select on the Rankings tab.
/// - `-ScreenshotSort byRankingAscending`: a ``SortMethod`` raw value.
/// - `-ScreenshotSearch Texas`: opens Choose Team on the Rankings tab with this search.
enum ScreenshotMode {
    static let isEnabled = ProcessInfo.processInfo.arguments.contains("-ScreenshotMode")

    static var tab: AppTab? {
        argument("-ScreenshotTab").flatMap { value(AppTab(rawValue: $0), for: "-ScreenshotTab", $0) }
    }

    static var stat: String? {
        argument("-ScreenshotStat")
    }

    static var teamSearch: String? {
        argument("-ScreenshotSearch")
    }

    static var sortMethod: SortMethod? {
        argument("-ScreenshotSort").flatMap { value(SortMethod(rawValue: $0), for: "-ScreenshotSort", $0) }
    }

    private static let logger = Logger(category: "ScreenshotMode")

    /// The value after a launch argument such as `-ScreenshotStat TurnoverMargin`.
    private static func argument(_ flag: String) -> String? {
        guard isEnabled else { return nil }
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: flag), arguments.indices.contains(index + 1) else { return nil }
        return arguments[index + 1]
    }

    /// Logs a misspelled argument, so it doesn't silently leave a screen unchanged.
    private static func value<Value>(_ value: Value?, for flag: String, _ rawValue: String) -> Value? {
        if value == nil {
            logger.error("Unknown \(flag, privacy: .public) value: \(rawValue, privacy: .public)")
        }
        return value
    }
}
#endif
