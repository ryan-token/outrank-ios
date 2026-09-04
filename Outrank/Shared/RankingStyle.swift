//
//  RankingStyle.swift
//  Outrank
//
//  Created by Ryan Token on 9/4/26.
//

import SwiftUI

/// Styling rules shared by every view that shows a team's ranking in a stat.
nonisolated enum RankingStyle {
    /// A ranking in the better half of the FBS field reads as good. Derived from
    /// the team list so it stays correct as programs join or leave FBS.
    static var goodRankingCutoff: Int {
        AllTeams.teams.count / 2
    }

    /// Green for the better half of the field, red for the worse half, and a
    /// neutral tint for teams with no ranking — an unranked team has not played
    /// badly, it has no result at all.
    static func color(for ranking: Int) -> Color {
        if ranking == RankingsResponse.unranked { return .secondary }
        return ranking <= goodRankingCutoff ? .green : .red
    }
}
