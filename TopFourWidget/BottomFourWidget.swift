//
//  BottomFourWidget.swift
//  BottomFourWidgetExtension
//
//  Created by Ryan Token on 10/15/21.
//

import WidgetKit
import SwiftUI

nonisolated struct BottomFourEntry: TimelineEntry {
    let date: Date
    let teamRankings: [String: Int]
}

nonisolated struct BottomFourProvider: TimelineProvider {
    func placeholder(in context: Context) -> BottomFourEntry {
        BottomFourEntry(
            date: .now,
            teamRankings: (try? Team.exampleTeam.allProperties()) ?? ["test": 99999]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (BottomFourEntry) -> Void) {
        let entry = BottomFourEntry(
            date: .now,
            teamRankings: (try? Team.exampleTeam.allProperties()) ?? ["test": 99999]
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<BottomFourEntry>) -> Void) {
        Task {
            let timeline = await loadTimeline()
            completion(timeline)
        }
    }

    private func loadTimeline() async -> Timeline<BottomFourEntry> {
        let teamName = UserDefaults(suiteName: AppGroup.groupId.rawValue)?
            .string(forKey: "WidgetTeam") ?? "Air Force"

        do {
            let team = try await TeamFetcher.getTeamRankingsFor(team: teamName)
            let entry = try BottomFourEntry(date: .now, teamRankings: team.allProperties())
            return Timeline(entries: [entry], policy: .after(nextUpdateDate()))
        } catch {
            print("Error fetching team rankings: \(error)")
            let entry = BottomFourEntry(date: .now, teamRankings: [:])
            return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(3600)))
        }
    }

    private func nextUpdateDate() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: .now)
        components.day = (components.day ?? 0) + 1
        components.hour = 10
        return calendar.date(from: components) ?? .now.addingTimeInterval(3600)
    }
}

struct BottomFourWidget: Widget {
    let kind: String = "BottomFourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BottomFourProvider()) { entry in
            TopOrBottomFourView(type: .bottomFour, teamRankings: entry.teamRankings)
        }
        .configurationDisplayName("Bottom Four Widget")
        .description("A team's bottom four stats. Change the team in the app's Settings page.")
        .supportedFamilies([.systemMedium])
    }
}
