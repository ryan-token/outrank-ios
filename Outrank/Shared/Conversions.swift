//
//  Conversions.swift
//  Outrank
//
//  Created by Ryan Token on 10/20/21.
//

import Foundation

nonisolated enum Conversions {
    /// A readable stat name from the API's camel-cased key, such as "ScoringOffense"
    /// becoming "Scoring Offense".
    static func humanReadableStat(for stat: String) -> String {
        stat == "DefensiveTDs" ? "Defensive TDs" : stat.camelCaseToWords()
    }

    /// An English ordinal for a ranking, such as "1st" or "112th", or "Unknown" for a
    /// team with no ranking in the stat.
    static func humanReadableRanking(for ranking: Int) -> String {
        if ranking == RankingsResponse.unranked { return "Unknown" }

        // Teens always take "th" (11th, 12th, 13th, 111th, ...).
        if (11...13).contains(ranking % 100) { return "\(ranking)th" }

        return switch ranking % 10 {
        case 1: "\(ranking)st"
        case 2: "\(ranking)nd"
        case 3: "\(ranking)rd"
        default: "\(ranking)th"
        }
    }
}
