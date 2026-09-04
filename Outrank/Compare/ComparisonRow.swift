//
//  ComparisonRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonRow: View {
    let stat: String
    let teamOneRanking: Int
    let teamTwoRanking: Int

    var body: some View {
        VStack {
            Text(Conversions.getHumanReadableStat(for: stat))
                .font(.headline)

            HStack {
                Text(Conversions.getHumanReadableRanking(for: teamOneRanking))
                    .foregroundStyle(color(for: teamOneRanking, comparedTo: teamTwoRanking))

                Spacer()

                Text(Conversions.getHumanReadableRanking(for: teamTwoRanking))
                    .foregroundStyle(color(for: teamTwoRanking, comparedTo: teamOneRanking))
            }
            .padding(.horizontal)
            .padding(.vertical, 3)
        }
    }

    private func color(for ranking: Int, comparedTo other: Int) -> Color {
        // A team with no ranking in this stat has not lost the comparison, so it
        // gets a neutral tint rather than being colored as the worse of the two.
        guard ranking != RankingsResponse.unranked else { return .secondary }

        if ranking < other {
            return .green
        } else if ranking > other {
            return .red
        } else {
            return .yellow
        }
    }
}
