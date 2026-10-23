//
//  TopOrBottomFourView.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI
import WidgetKit

struct TopOrBottomFourView: View {
    let type: WidgetType
    let team: String
    let rankings: [String: Int]

    /// The team's four best or worst ranked stats, ignoring stats it isn't ranked in.
    private var rankedFour: [RankingEntry] {
        let ranked = rankings.compactMap { stat, ranking in
            ranking == RankingsResponse.unranked
                ? nil
                : RankingEntry(id: stat, title: Conversions.humanReadableStat(for: stat), ranking: ranking)
        }

        return Array(type.sortMethod.sorted(ranked).prefix(4))
    }

    var body: some View {
        let entries = rankedFour

        VStack {
            Text(type.title(for: team))
                .foregroundStyle(.secondary)

            if entries.isEmpty {
                Text("No Data")
            } else {
                ForEach(entries) { entry in
                    WidgetRankingRow(title: entry.title, ranking: entry.ranking, rankingColor: type.rankingColor)
                }
            }
        }
        .padding()
        .font(.headline)
        .foregroundStyle(.primary)
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

#Preview(as: .systemMedium) {
    TopFourWidget()
} timeline: {
    TeamRankingsEntry(
        date: .now,
        team: "Tulsa",
        rankings: ["ScoringOffense": 3, "TotalOffense": 7, "RushingOffense": 11, "TurnoverMargin": 14]
    )
}
