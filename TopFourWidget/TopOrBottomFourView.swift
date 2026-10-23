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
    private var rankedFour: [(key: String, value: Int)] {
        let ranked = rankings.filter { $0.value != RankingsResponse.unranked }

        let sorted: [(key: String, value: Int)] = switch type {
        case .topFour: ranked.sorted { ($0.value, $0.key) < ($1.value, $1.key) }
        case .bottomFour: ranked.sorted { ($0.value, $1.key) > ($1.value, $0.key) }
        }

        return Array(sorted.prefix(4))
    }

    var body: some View {
        let rankedFour = rankedFour

        VStack {
            Text(type.title(for: team))
                .foregroundStyle(.secondary)

            if rankedFour.isEmpty {
                Text("No Data")
            } else {
                ForEach(rankedFour, id: \.key) { item in
                    WidgetRankingRow(
                        stat: item.key,
                        ranking: item.value,
                        rankingColor: type.rankingColor
                    )
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
