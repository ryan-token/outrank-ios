//
//  TopOrBottomFourView.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI

enum WidgetType {
    case topFour
    case bottomFour

    func title(for team: String) -> String {
        switch self {
        case .topFour: "\(team)'s Top Four"
        case .bottomFour: "\(team)'s Bottom Four"
        }
    }

    var rankingColor: Color {
        switch self {
        case .topFour: .green
        case .bottomFour: .red
        }
    }
}

struct TopOrBottomFourView: View {
    let type: WidgetType
    let team: String
    let rankings: [String: Int]

    private var sortedFour: [(key: String, value: Int)] {
        let ranked = rankings.filter { $0.value != RankingsResponse.unranked }

        let sorted: [(key: String, value: Int)] = switch type {
        case .topFour: ranked.sorted { $0.value < $1.value }
        case .bottomFour: ranked.sorted { $0.value > $1.value }
        }

        return Array(sorted.prefix(4))
    }

    var body: some View {
        VStack(spacing: 6) {
            Text(type.title(for: team))
                .foregroundStyle(.secondary)

            if sortedFour.isEmpty {
                Text("No Data")
            } else {
                ForEach(sortedFour, id: \.key) { item in
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

private struct WidgetRankingRow: View {
    let stat: String
    let ranking: Int
    let rankingColor: Color

    var body: some View {
        HStack {
            Text("\(Conversions.getHumanReadableStat(for: stat)):")
            Spacer()
            Text(Conversions.getHumanReadableRanking(for: ranking))
                .foregroundStyle(rankingColor)
        }
    }
}

#Preview {
    TopOrBottomFourView(
        type: .topFour,
        team: "Tulsa",
        rankings: ["ScoringOffense": 3, "TotalOffense": 7, "RushingOffense": 11, "TurnoverMargin": 14]
    )
}
