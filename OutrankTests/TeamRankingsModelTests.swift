//
//  TeamRankingsModelTests.swift
//  OutrankTests
//

import Foundation
import Testing
@testable import Outrank

struct TeamRankingsModelTests {
    private let rankings = ["ScoringOffense": 3, "BlockedKicks": 40, "TotalDefense": 12]

    @Test func chosenTeamIsRestoredOnNextLaunch() {
        let defaults = makeIsolatedDefaults()
        TeamRankingsModel(defaults: defaults) { _ in RankingsResponse() }.team = "SMU"

        let relaunched = TeamRankingsModel(defaults: defaults) { _ in RankingsResponse() }

        #expect(relaunched.team == "SMU")
    }

    @Test func changingTeamDropsThePreviousTeamsRankings() async {
        let model = TeamRankingsModel(defaults: makeIsolatedDefaults()) { _ in RankingsResponse(rankings: rankings) }
        await model.load()

        model.team = "SMU"

        #expect(model.sortedRankings.isEmpty)
        #expect(model.ranking(forStat: "TotalDefense") == RankingsResponse.unranked)
    }

    @Test func loadSortsRankingsWithReadableTitles() async {
        var requestedTeams: [String] = []
        let model = TeamRankingsModel(defaults: makeIsolatedDefaults()) { team in
            requestedTeams.append(team)
            return RankingsResponse(rankings: rankings)
        }

        let loaded = await model.load()

        #expect(loaded)
        #expect(requestedTeams == [TeamRankingsModel.defaultTeam])
        #expect(model.sortedRankings.map(\.id) == ["BlockedKicks", "ScoringOffense", "TotalDefense"])
        #expect(model.sortedRankings.first?.title == "Blocked Kicks")
        #expect(model.ranking(forStat: "TotalDefense") == 12)
        #expect(model.ranking(forStat: "Missing") == RankingsResponse.unranked)
        #expect(!model.loadFailed)
    }

    @Test func changingTheSortOrderResortsAndBumpsTheRevision() async {
        let model = TeamRankingsModel(defaults: makeIsolatedDefaults()) { _ in RankingsResponse(rankings: rankings) }
        await model.load()
        let revision = model.revision

        model.sortMethod = .byRankingAscending

        #expect(model.sortedRankings.map(\.ranking) == [3, 12, 40])
        #expect(model.revision > revision)
    }

    @Test func failedLoadIsReportedAndKeepsPreviousRankings() async {
        var shouldFail = false
        let model = TeamRankingsModel(defaults: makeIsolatedDefaults()) { _ in
            if shouldFail { throw StubError() }
            return RankingsResponse(rankings: rankings)
        }
        await model.load()

        shouldFail = true
        let loaded = await model.load()

        #expect(!loaded)
        #expect(model.loadFailed)
        #expect(model.sortedRankings.count == rankings.count)
    }

    @Test func responseForAPreviousTeamIsIgnored() async {
        let reference = ModelReference<TeamRankingsModel>()
        let model = TeamRankingsModel(defaults: makeIsolatedDefaults()) { _ in
            // The user picks another team while this request is in flight.
            reference.model?.team = "SMU"
            return RankingsResponse(rankings: ["ScoringOffense": 1])
        }
        reference.model = model

        let loaded = await model.load()

        #expect(!loaded)
        #expect(model.sortedRankings.isEmpty)
    }

    @Test func cancelledLoadIsNotReportedAsAFailure() async {
        let model = TeamRankingsModel(defaults: makeIsolatedDefaults()) { _ in
            // SwiftUI cancels the task when the view disappears or the team changes.
            withUnsafeCurrentTask { $0?.cancel() }
            throw CancellationError()
        }

        let loaded = await Task { await model.load() }.value

        #expect(!loaded)
        #expect(!model.loadFailed)
    }
}
