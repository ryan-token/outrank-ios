//
//  ComparisonAverages.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonAverages: View {
    let teamOne: String
    let teamTwo: String
    let teamOneRankings: [String: Int]
    let teamTwoRankings: [String: Int]

    var body: some View {
        HStack {
            Text("Simple Average: \(Utils.getSimpleAverageFor(teamOneRankings))")
                .accessibilityLabel("\(teamOne)'s Average Ranking: \(Utils.getSimpleAverageFor(teamOneRankings))")

            Spacer()

            Text("Simple Average: \(Utils.getSimpleAverageFor(teamTwoRankings))")
                .accessibilityLabel("\(teamTwo)'s Average Ranking: \(Utils.getSimpleAverageFor(teamTwoRankings))")
        }
        .foregroundStyle(.secondary)
        .font(.subheadline)
        .padding(.horizontal, 25)
        .padding(.top, 15)
    }
}
