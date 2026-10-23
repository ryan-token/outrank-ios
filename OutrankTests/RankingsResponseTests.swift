//
//  RankingsResponseTests.swift
//  OutrankTests
//

import Foundation
import Testing
@testable import Outrank

struct RankingsResponseTests {
    @Test func decodesRankingsAndSkipsTheNameField() throws {
        let json = Data(#"{"team": "Tulsa", "ScoringOffense": 3, "TotalDefense": 99999}"#.utf8)
        let response = try JSONDecoder().decode(RankingsResponse.self, from: json)

        #expect(response.rankings == ["ScoringOffense": 3, "TotalDefense": RankingsResponse.unranked])
        #expect(response.ranking(for: "Missing") == RankingsResponse.unranked)
    }
}
