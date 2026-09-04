//
//  Utils.swift
//  Outrank
//
//  Created by Ryan Token on 10/23/21.
//

import Foundation

nonisolated enum Utils {
    static func getSimpleAverageFor(_ teamRankings: [String: Int]) -> String {
        let rankings = teamRankings.values.filter { $0 != RankingsResponse.unranked }

        // A team that is not ranked in anything yet has no average to show. Say so
        // rather than rendering a bare "Simple Average: " that VoiceOver reads as empty.
        guard !rankings.isEmpty else { return "Unknown" }

        let sum = rankings.reduce(0, +)
        guard sum != 0 else { return "0" }

        return String(sum / rankings.count)
    }
}
