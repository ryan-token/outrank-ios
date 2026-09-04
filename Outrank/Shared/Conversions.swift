//
//  Conversions.swift
//  Outrank
//
//  Created by Ryan Token on 10/20/21.
//

import Foundation

nonisolated enum Conversions {
    static func getHumanReadableStat(for stat: String) -> String {
        if stat != "DefensiveTDs" {
            let cleanStat = stat.camelCaseToWords()
            return cleanStat
        } else {
            return "Defensive TDs"
        }
    }

    static func getHumanReadableRanking(for ranking: Int) -> String {
        if ranking == RankingsResponse.unranked { return "Unknown" }

        // Teens always take "th" (11th, 12th, 13th, 111th, ...).
        let lastTwo = ranking % 100
        if (11...13).contains(lastTwo) { return "\(ranking)th" }

        switch ranking % 10 {
        case 1: return "\(ranking)st"
        case 2: return "\(ranking)nd"
        case 3: return "\(ranking)rd"
        default: return "\(ranking)th"
        }
    }
}
