//
//  RankingStatisticsTests.swift
//  OutrankTests
//

import Testing
@testable import Outrank

struct RankingStatisticsTests {
    @Test func noRankingsHasNoAverage() {
        #expect(RankingStatistics.simpleAverage(of: [:]) == nil)
    }

    @Test func onlyUnrankedStatsHasNoAverage() {
        let rankings = ["A": RankingsResponse.unranked, "B": RankingsResponse.unranked]
        #expect(RankingStatistics.simpleAverage(of: rankings) == nil)
    }

    @Test func unrankedStatsAreLeftOutOfTheAverage() {
        let rankings = ["A": 10, "B": 20, "C": RankingsResponse.unranked]
        #expect(RankingStatistics.simpleAverage(of: rankings) == 15)
    }

    @Test(arguments: [
        (["A": 10, "B": 21], 16), // 15.5 rounds up
        (["A": 10, "B": 12, "C": 21], 14) // 14.33 rounds down
    ])
    func averageRoundsToTheNearestRanking(rankings: [String: Int], expected: Int) {
        #expect(RankingStatistics.simpleAverage(of: rankings) == expected)
    }
}
