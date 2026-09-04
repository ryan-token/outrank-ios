//
//  TeamRankingsProvider.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 9/4/26.
//

import WidgetKit

nonisolated struct TeamRankingsEntry: TimelineEntry {
    let date: Date

    /// Carried on the entry rather than read by the view, so the name on screen always
    /// describes the rankings alongside it — even if the user picks a different team
    /// before WidgetKit asks for a new timeline.
    let team: String

    let rankings: [String: Int]
}

/// Shared by the top-four and bottom-four widgets; they differ only in how they sort.
nonisolated struct TeamRankingsProvider: TimelineProvider {
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
            let response = try await TeamFetcher.getTeamRankingsFor(team: team)
            let entry = TeamRankingsEntry(date: .now, team: team, rankings: response.rankings)
            return Timeline(entries: [entry], policy: .after(Self.nextUpdateDate()))
        } catch {
            print("Error fetching team rankings: \(error)")
            let entry = TeamRankingsEntry(date: .now, team: team, rankings: [:])
            return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
        }
    }

    private static var selectedTeam: String {
        UserDefaults(suiteName: AppGroup.groupId.rawValue)?
            .string(forKey: "WidgetTeam") ?? "Air Force"
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

    /// The scraper refreshes the rankings each morning, so ask again after it has run.
    private static func nextUpdateDate() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: .now)
        components.day = (components.day ?? 0) + 1
        components.hour = 10
        return calendar.date(from: components) ?? .now.addingTimeInterval(3600)
    }
}
