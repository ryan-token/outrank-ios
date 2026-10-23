//
//  RankingStatistics.swift
//  Outrank
//
//  Created by Ryan Token on 10/23/21.
//

import Foundation

nonisolated enum RankingStatistics {
    /// The mean of a team's rankings across every stat it is ranked in, or `nil` when it
    /// is not ranked in anything yet. Unranked stats are left out rather than dragging
    /// the average toward the API's sentinel value.
    static func simpleAverage(of rankings: [String: Int]) -> Int? {
        let ranked = rankings.values.filter { $0 != RankingsResponse.unranked }
        guard !ranked.isEmpty else { return nil }
        return ranked.reduce(0, +) / ranked.count
    }
}
