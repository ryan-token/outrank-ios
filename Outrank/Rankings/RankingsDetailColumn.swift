//
//  RankingsDetailColumn.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

/// The split view's detail column: the selected stat, or a placeholder until there is one.
struct RankingsDetailColumn: View {
    let model: TeamRankingsModel
    let selectedStat: String?

    var body: some View {
        if let selectedStat {
            RankingDetailView(
                team: model.team,
                stat: selectedStat,
                ranking: model.ranking(forStat: selectedStat)
            )
            // A new stat gets fresh state rather than briefly showing the last one's rankings.
            .id(selectedStat)
        } else {
            WelcomeView(type: .rankings)
        }
    }
}
