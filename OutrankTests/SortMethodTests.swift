//
//  SortMethodTests.swift
//  OutrankTests
//

import Testing
@testable import Outrank

struct SortMethodTests {
    private let entries = [
        RankingEntry(id: "RushingOffense", title: "Rushing Offense", ranking: 40),
        RankingEntry(id: "BlockedKicks", title: "Blocked Kicks", ranking: 12),
        RankingEntry(id: "TotalDefense", title: "Total Defense", ranking: 12),
        RankingEntry(id: "FumblesLost", title: "Fumbles Lost", ranking: RankingsResponse.unranked)
    ]

    @Test func alphabeticalByStat() {
        let ids = SortMethod.byStatAlphabetically.sorted(entries).map(\.id)
        #expect(ids == ["BlockedKicks", "FumblesLost", "RushingOffense", "TotalDefense"])
    }

    @Test func reverseAlphabeticalByStat() {
        let ids = SortMethod.byStatReverseAlphabetically.sorted(entries).map(\.id)
        #expect(ids == ["TotalDefense", "RushingOffense", "FumblesLost", "BlockedKicks"])
    }

    @Test func bestToWorstBreaksTiesAlphabetically() {
        let ids = SortMethod.byRankingAscending.sorted(entries).map(\.id)
        #expect(ids == ["BlockedKicks", "TotalDefense", "RushingOffense", "FumblesLost"])
    }

    @Test func worstToBestBreaksTiesAlphabetically() {
        let ids = SortMethod.byRankingDescending.sorted(entries).map(\.id)
        #expect(ids == ["FumblesLost", "RushingOffense", "BlockedKicks", "TotalDefense"])
    }

    @Test func sectionLabelScopesRankingSortsToTheTeam() {
        #expect(SortMethod.byRankingAscending.sectionLabel(rankingPrefix: "Tulsa") == "Tulsa Ranking (best → worst)")
        #expect(SortMethod.byStatAlphabetically.sectionLabel(rankingPrefix: "Tulsa") == "Stat (A → Z)")
    }
}
