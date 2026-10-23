//
//  StatRankingsModelTests.swift
//  OutrankTests
//

import Testing
@testable import Outrank

struct StatRankingsModelTests {
    @Test func entriesAreBestFirstWithDisplayNames() async {
        var requestedStats: [String] = []
        let model = StatRankingsModel { stat in
            requestedStats.append(stat)
            return RankingsResponse(rankings: ["TexasAM": 9, "MiamiFL": 2, "Tulsa": 9])
        }

        await model.load(stat: "ScoringOffense")

        #expect(requestedStats == ["ScoringOffense"])
        #expect(model.entries.map(\.title) == ["Miami (FL)", "Texas A&M", "Tulsa"])
        #expect(!model.loadFailed)
    }

    @Test func unknownTeamKeysStillReadSensibly() async {
        let model = StatRankingsModel { _ in RankingsResponse(rankings: ["NewProgram": 1]) }
        await model.load(stat: "ScoringOffense")
        #expect(model.entries.first?.title == "New Program")
    }

    @Test func failedLoadIsReported() async {
        let model = StatRankingsModel { _ in throw StubError() }
        await model.load(stat: "ScoringOffense")
        #expect(model.loadFailed)
        #expect(model.entries.isEmpty)
    }
}
