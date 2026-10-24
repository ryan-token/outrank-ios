//
//  ComparisonRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonRow: View {
    let title: String
    let teamOne: String
    let teamOneRanking: Int
    let teamTwo: String
    let teamTwoRanking: Int

    var body: some View {
        let teamOneText = Conversions.humanReadableRanking(for: teamOneRanking)
        let teamTwoText = Conversions.humanReadableRanking(for: teamTwoRanking)

        VStack {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            HStack {
                Text(teamOneText)
                    .foregroundStyle(RankingStyle.comparisonColor(for: teamOneRanking, comparedTo: teamTwoRanking))

                Spacer()

                Text(teamTwoText)
                    .foregroundStyle(RankingStyle.comparisonColor(for: teamTwoRanking, comparedTo: teamOneRanking))
            }
            .padding(.horizontal)
        }
        // Names each team, since only position and color tell the two rankings apart:
        // "Scoring Offense: Tulsa 3rd, SMU 50th".
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title): \(teamOne) \(teamOneText), \(teamTwo) \(teamTwoText)")
    }
}
