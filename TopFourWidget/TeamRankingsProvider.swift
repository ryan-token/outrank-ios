//
//  TeamRankingsProvider.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 9/4/26.
//

import OSLog
import WidgetKit

/// Shared by the top-four and bottom-four widgets; they differ only in how they sort.
nonisolated struct TeamRankingsProvider: TimelineProvider {
    private static let logger = Logger(category: "TeamRankingsProvider")

    func placeholder(in context: Context) -> TeamRankingsEntry {
        TeamRankingsEntry(date: .now, team: Self.selectedTeam, rankings: Self.sampleRankings)
    }

    func getSnapshot(in context: Context, completion: @escaping @Sendable (TeamRankingsEntry) -> Void) {
        // In the gallery there is no time to hit the network, so show sample data.
        completion(TeamRankingsEntry(date: .now, team: Self.selectedTeam, rankings: Self.sampleRankings))
    }

    // TimelineProvider only offers the completion-handler form, so bridge to async here.
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<TeamRankingsEntry>) -> Void) {
        Task {
            completion(await loadTimeline())
        }
    }

    private func loadTimeline() async -> Timeline<TeamRankingsEntry> {
        let team = Self.selectedTeam

        do {
            let response = try await RankingsAPI.teamRankings(for: team)
            Self.cacheRankings(response.rankings, for: team)
            let entry = TeamRankingsEntry(date: .now, team: team, rankings: response.rankings)
            return Timeline(entries: [entry], policy: .after(Self.nextUpdateDate()))
        } catch {
            Self.logger.error("Failed to fetch rankings for \(team, privacy: .public): \(String(describing: error))")
            // Keep showing the last good rankings through a brief outage, and try again soon.
            let entry = TeamRankingsEntry(date: .now, team: team, rankings: Self.cachedRankings(for: team))
            return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
        }
    }

    // The widget extension's own defaults: the app never reads this cache.
    private static let cachedTeamKey = "CachedTeam"
    private static let cachedRankingsKey = "CachedRankings"

    private static func cacheRankings(_ rankings: [String: Int], for team: String) {
        UserDefaults.standard.set(team, forKey: cachedTeamKey)
        UserDefaults.standard.set(rankings, forKey: cachedRankingsKey)
    }

    /// The last rankings fetched for `team`, or none if the widget has since switched teams.
    private static func cachedRankings(for team: String) -> [String: Int] {
        guard UserDefaults.standard.string(forKey: cachedTeamKey) == team else { return [:] }
        return UserDefaults.standard.dictionary(forKey: cachedRankingsKey) as? [String: Int] ?? [:]
    }

    private static var selectedTeam: String {
        AppGroup.defaults?.string(forKey: AppGroup.widgetTeamKey) ?? AppGroup.defaultWidgetTeam
    }

    /// Enough spread that both the top-four and bottom-four widgets look right in the gallery.
    private static let sampleRankings: [String: Int] = [
        "ScoringOffense": 3,
        "TotalOffense": 7,
        "RushingOffense": 11,
        "TurnoverMargin": 14,
        "PassingYardsAllowed": 121,
        "SacksAllowed": 124,
        "FewestPenalties": 128,
        "RedZoneDefense": 131
    ]

    /// The scraper refreshes the rankings each morning, so ask again at the next 10am
    /// Central, after it has run. A fixed time zone keeps every user's refresh after the
    /// scraper's, wherever they are.
    private static func nextUpdateDate() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago") ?? .current

        return calendar.nextDate(
            after: .now,
            matching: DateComponents(hour: 10, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) ?? .now.addingTimeInterval(3600)
    }
}
