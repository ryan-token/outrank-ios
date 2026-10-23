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
        let rankings = ["A": 10, "B": 21, "C": RankingsResponse.unranked]
        #expect(RankingStatistics.simpleAverage(of: rankings) == 15)
    }
}
