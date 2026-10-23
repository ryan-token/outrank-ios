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
    private static let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "TeamRankingsProvider")

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
            let entry = TeamRankingsEntry(date: .now, team: team, rankings: response.rankings)
            return Timeline(entries: [entry], policy: .after(Self.nextUpdateDate()))
        } catch {
            Self.logger.error("Failed to fetch rankings for \(team, privacy: .public): \(error.localizedDescription)")
            let entry = TeamRankingsEntry(date: .now, team: team, rankings: [:])
            return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
        }
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

    /// The scraper refreshes the rankings each morning, so ask again at the next 10am,
    /// after it has run.
    private static func nextUpdateDate() -> Date {
        Calendar.current.nextDate(
            after: .now,
            matching: DateComponents(hour: 10, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) ?? .now.addingTimeInterval(3600)
    }
}
