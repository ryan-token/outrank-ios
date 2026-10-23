//
//  ConversionsTests.swift
//  OutrankTests
//

import Testing
@testable import Outrank

struct ConversionsTests {
    @Test(arguments: [
        (1, "1st"), (2, "2nd"), (3, "3rd"), (4, "4th"), (10, "10th"),
        (11, "11th"), (12, "12th"), (13, "13th"),
        (21, "21st"), (22, "22nd"), (23, "23rd"),
        (101, "101st"), (111, "111th"), (112, "112th"), (113, "113th"), (136, "136th")
    ])
    func ordinalRankings(ranking: Int, expected: String) {
        #expect(Conversions.humanReadableRanking(for: ranking) == expected)
    }

    @Test func unrankedReadsAsUnknown() {
        #expect(Conversions.humanReadableRanking(for: RankingsResponse.unranked) == "Unknown")
    }

    @Test(arguments: [
        ("ScoringOffense", "Scoring Offense"),
        ("TeamPassingEfficiencyDefense", "Team Passing Efficiency Defense"),
        ("DefensiveTDs", "Defensive TDs"),
        ("Simple", "Simple")
    ])
    func readableStatNames(stat: String, expected: String) {
        #expect(Conversions.humanReadableStat(for: stat) == expected)
    }
}
