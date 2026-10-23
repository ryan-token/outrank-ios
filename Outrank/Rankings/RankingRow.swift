//
//  RankingRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

/// A stat and the selected team's ranking in it.
struct RankingRow: View {
    let title: String
    let ranking: Int

    var body: some View {
        // LabeledContent stacks the ranking under the stat name at accessibility text
        // sizes instead of squeezing both onto one line.
        LabeledContent {
            Text(Conversions.humanReadableRanking(for: ranking))
                .foregroundStyle(RankingStyle.color(for: ranking))
        } label: {
            Text(title)
                .font(.headline)
        }
    }
}
