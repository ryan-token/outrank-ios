//
//  ComparisonModelTests.swift
//  OutrankTests
//

import Foundation
import Testing
@testable import Outrank

struct ComparisonModelTests {
    private static let stubRankings: [String: [String: Int]] = [
        "Tulsa": ["ScoringOffense": 10, "TotalDefense": 30, "BlockedKicks": RankingsResponse.unranked],
        "SMU": ["ScoringOffense": 20, "TotalDefense": 30]
    ]

    private func makeModel(defaults: UserDefaults = makeIsolatedDefaults()) -> ComparisonModel {
        ComparisonModel(defaults: defaults) { team in
            RankingsResponse(rankings: Self.stubRankings[team] ?? [:])
        }
    }

    @Test func subscriptReadsAndWritesEachSlot() {
        let defaults = makeIsolatedDefaults()
        let model = makeModel(defaults: defaults)

        model[team: .teamTwo] = "Rice"

        #expect(model[team: .teamOne] == "Tulsa")
        #expect(model.teamTwo == "Rice")
        #expect(defaults.string(forKey: ComparisonModel.teamTwoKey) == "Rice")
    }

    @Test func pickingANewTeamDropsTheSlotsOldRankings() async {
        let model = makeModel()
        await model.loadBothTeams()

        model[team: .teamTwo] = "Rice"

        // Nothing of SMU's may show under Rice's name while Rice loads.
        #expect(model.teamTwoRankings.isEmpty)
        #expect(model.teamTwoAverage == nil)
        #expect(model.rows.allSatisfy { $0.teamTwoRanking == RankingsResponse.unranked })
        #expect(model.teamOneAverage == 20)
    }

    @Test func eachSlotAwaitsItsFirstLoadUntilItLoadsOrFails() async {
        let model = ComparisonModel(defaults: makeIsolatedDefaults()) { team in
            if team == "SMU" { throw StubError() }
            return RankingsResponse(rankings: Self.stubRankings[team] ?? [:])
        }
        #expect(model.isAwaitingFirstLoad(.teamOne))
        #expect(model.isAwaitingFirstLoad(.teamTwo))

        await model.loadBothTeams()
        #expect(!model.isAwaitingFirstLoad(.teamOne))
        // A failed load shows "Unknown", not a placeholder that never resolves.
        #expect(!model.isAwaitingFirstLoad(.teamTwo))

        model[team: .teamOne] = "Rice"
        #expect(model.isAwaitingFirstLoad(.teamOne))
    }

    @Test func swappedTeamsAreNotFetchedAgain() async {
        var fetchCount = 0
        let model = ComparisonModel(defaults: makeIsolatedDefaults()) { team in
            fetchCount += 1
            return RankingsResponse(rankings: Self.stubRankings[team] ?? [:])
        }
        await model.loadStaleTeams()

        model.swapTeams()
        await model.loadStaleTeams()

        #expect(fetchCount == 2)
    }

    @Test func staleRankingsAreFetchedAgain() async {
        var clock = Date.now
        var fetchCount = 0
        let model = ComparisonModel(
            defaults: makeIsolatedDefaults(),
            fetch: { team in
                fetchCount += 1
                return RankingsResponse(rankings: Self.stubRankings[team] ?? [:])
            },
            now: { clock }
        )
        await model.loadStaleTeams()

        clock += ComparisonModel.maxRankingsAge - 1
        await model.loadStaleTeams()
        #expect(fetchCount == 2)

        clock += 2
        await model.loadStaleTeams()
        #expect(fetchCount == 4)
    }

    @Test func failedTeamIsFetchedAgainEvenWhenRecent() async {
        var shouldFail = true
        let model = ComparisonModel(defaults: makeIsolatedDefaults()) { team in
            if shouldFail, team == "SMU" { throw StubError() }
            return RankingsResponse(rankings: Self.stubRankings[team] ?? [:])
        }
        await model.loadStaleTeams()

        shouldFail = false
        await model.loadStaleTeams()

        #expect(!model.loadFailed)
        #expect(model.teamTwoAverage == 25)
    }

    @Test func rowsLineUpBothTeamsByStat() async throws {
        let model = makeModel()

        await model.loadBothTeams()

        #expect(model.rows.map(\.id) == ["BlockedKicks", "ScoringOffense", "TotalDefense"])
        let scoring = try #require(model.rows.first { $0.id == "ScoringOffense" })
        #expect(scoring.teamOneRanking == 10)
        #expect(scoring.teamTwoRanking == 20)
        // SMU has no BlockedKicks ranking, so it reads as unranked.
        #expect(model.rows.first?.teamTwoRanking == RankingsResponse.unranked)
        #expect(model.teamOneAverage == 20)
        #expect(model.teamTwoAverage == 25)
        #expect(!model.loadFailed)
    }

    @Test func swapExchangesTeamsAndTheirLoadedData() async {
        let defaults = makeIsolatedDefaults()
        let model = makeModel(defaults: defaults)
        await model.loadBothTeams()

        model.swapTeams()

        #expect(model.teamOne == "SMU")
        #expect(model.teamTwo == "Tulsa")
        #expect(model.teamOneAverage == 25)
        #expect(model.rows.map(\.id) == ["ScoringOffense", "TotalDefense"])
        #expect(model.rows.first?.teamTwoRanking == 10)
        #expect(defaults.string(forKey: ComparisonModel.teamOneKey) == "SMU")
        #expect(defaults.string(forKey: ComparisonModel.teamTwoKey) == "Tulsa")
    }

    @Test func sortingFollowsTeamOneRankings() async {
        let model = makeModel()
        await model.loadBothTeams()

        model.sortMethod = .byRankingAscending

        #expect(model.rows.map(\.id) == ["ScoringOffense", "TotalDefense", "BlockedKicks"])
    }

    @Test func eachTeamReportsItsOwnFailure() async {
        let model = ComparisonModel(defaults: makeIsolatedDefaults()) { team in
            if team == "SMU" { throw StubError() }
            return RankingsResponse(rankings: ["ScoringOffense": 1])
        }

        await model.loadBothTeams()

        #expect(!model.teamOneLoadFailed)
        #expect(model.teamTwoLoadFailed)
        #expect(model.loadFailed)
        #expect(model.rows.count == 1)
    }

    @Test func responseForATeamNoLongerInTheSlotIsIgnored() async {
        let reference = ModelReference<ComparisonModel>()
        let model = ComparisonModel(defaults: makeIsolatedDefaults()) { _ in
            // The teams are swapped while this request is in flight.
            reference.model?.swapTeams()
            return RankingsResponse(rankings: ["ScoringOffense": 1])
        }
        reference.model = model

        await model.load(.teamOne)

        #expect(model.teamOneRankings.isEmpty)
        #expect(model.teamTwoRankings.isEmpty)
    }
}
