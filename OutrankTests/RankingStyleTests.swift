//
//  RankingStyleTests.swift
//  OutrankTests
//

import SwiftUI
import Testing
@testable import Outrank

struct RankingStyleTests {
    @Test func rankingColorSplitsTheFieldInHalf() {
        #expect(RankingStyle.color(for: 1) == .green)
        #expect(RankingStyle.color(for: RankingStyle.goodRankingCutoff) == .green)
        #expect(RankingStyle.color(for: RankingStyle.goodRankingCutoff + 1) == .red)
        #expect(RankingStyle.color(for: RankingsResponse.unranked) == .secondary)
    }

    @Test func comparisonColorReflectsWhoRanksBetter() {
        #expect(RankingStyle.comparisonColor(for: 5, comparedTo: 50) == .green)
        #expect(RankingStyle.comparisonColor(for: 50, comparedTo: 5) == .red)
        #expect(RankingStyle.comparisonColor(for: 7, comparedTo: 7) == .yellow)
    }

    @Test func unrankedTeamIsNeutralNotLosing() {
        #expect(RankingStyle.comparisonColor(for: RankingsResponse.unranked, comparedTo: 5) == .secondary)
        #expect(RankingStyle.comparisonColor(for: 5, comparedTo: RankingsResponse.unranked) == .green)
    }
}
