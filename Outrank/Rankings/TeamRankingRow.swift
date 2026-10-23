//
//  TeamRankingRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/4/21.
//

import SwiftUI

/// One team's ranking within a stat.
struct TeamRankingRow: View {
    let title: String
    let ranking: Int
    let isCurrentTeam: Bool

    var body: some View {
        LabeledContent {
            Text(Conversions.humanReadableRanking(for: ranking))
                .foregroundStyle(RankingStyle.color(for: ranking))
        } label: {
            Text(title)
        }
        .font(isCurrentTeam ? .headline : .body)
    }
}
