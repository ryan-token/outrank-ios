//
//  Utils.swift
//  Outrank
//
//  Created by Ryan Token on 10/23/21.
//

import Foundation

nonisolated enum Utils {
    static func getSimpleAverageFor(_ teamRankings: [String: Int]) -> String {
        let rankings = teamRankings.values.filter { $0 != 99999 }
        guard !rankings.isEmpty else { return "" }

        let sum = rankings.reduce(0, +)
        guard sum != 0 else { return "0" }

        return String(sum / rankings.count)
    }
}
