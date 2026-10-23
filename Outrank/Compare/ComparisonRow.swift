//
//  ComparisonRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonRow: View {
    let title: String
    let teamOneRanking: Int
    let teamTwoRanking: Int

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            HStack {
                Text(Conversions.humanReadableRanking(for: teamOneRanking))
                    .foregroundStyle(RankingStyle.comparisonColor(for: teamOneRanking, comparedTo: teamTwoRanking))

                Spacer()

                Text(Conversions.humanReadableRanking(for: teamTwoRanking))
                    .foregroundStyle(RankingStyle.comparisonColor(for: teamTwoRanking, comparedTo: teamOneRanking))
            }
            .padding(.horizontal)
        }
        // Read as one element: "Scoring Offense, 3rd, 50th".
        .accessibilityElement(children: .combine)
    }
}
