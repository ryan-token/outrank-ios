//
//  TopFourWidget.swift
//  TopFourWidget
//
//  Created by Ryan Token on 10/3/21.
//

import WidgetKit
import SwiftUI

nonisolated struct TopFourEntry: TimelineEntry {
    let date: Date
    let teamRankings: [String: Int]
}

nonisolated struct TopFourProvider: TimelineProvider {
    func placeholder(in context: Context) -> TopFourEntry {
        TopFourEntry(
            date: .now,
            teamRankings: (try? Team.exampleTeam.allProperties()) ?? ["test": 99999]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (TopFourEntry) -> Void) {
        let entry = TopFourEntry(
            date: .now,
            teamRankings: (try? Team.exampleTeam.allProperties()) ?? ["test": 99999]
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<TopFourEntry>) -> Void) {
        Task.detached {
            do {
                let team = try await TeamFetcher.getTeamRankingsFor(
                    team: UserDefaults(suiteName: AppGroup.groupId.rawValue)?
                        .string(forKey: "WidgetTeam") ?? "Air Force"
                )

                let entry = TopFourEntry(date: .now, teamRankings: try team.allProperties())
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate()))
                completion(timeline)
            } catch {
                print("Error fetching team rankings: \(error)")
                let entry = TopFourEntry(date: .now, teamRankings: [:])
                let timeline = Timeline(entries: [entry], policy: .after(Date.now.addingTimeInterval(3600)))
                completion(timeline)
            }
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

struct TopFourWidget: Widget {
    let kind: String = "TopFourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TopFourProvider()) { entry in
            TopOrBottomFourView(type: .topFour, teamRankings: entry.teamRankings)
        }
        .configurationDisplayName("Top Four Widget")
        .description("A team's top four stats. Change the team in the app's Settings page.")
        .supportedFamilies([.systemMedium])
    }
}

@main
struct TeamRankingsBundle: WidgetBundle {
    var body: some Widget {
        TopFourWidget()
        BottomFourWidget()
    }
}
