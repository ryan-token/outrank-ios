//
//  RankingsResponse.swift
//  Outrank
//
//  Created by Ryan Token on 9/4/26.
//

import Foundation

/// A rankings payload from the API.
///
/// Both endpoints return the same shape: a flat JSON object whose numeric values are
/// rankings, alongside a single string field naming the row — `team` when asking for
/// one team's ranking in every stat, `stat` when asking for every team's ranking in
/// one stat.
///
/// Decoding the numbers straight into a dictionary means neither the stat list nor the
/// team list has to be mirrored as Swift properties, so the app keeps working when the
/// backend adds an FBS program mid-season instead of failing to decode the response.
nonisolated struct RankingsResponse: Decodable, Equatable, Sendable {
    /// The value the API stores for a team that has no ranking in a stat, either
    /// because it has recorded none of it or because it has not played yet.
    static let unranked = 99999

    /// Each name in the payload mapped to its ranking. Keys are stat names for a team
    /// query and team names for a stat query.
    let rankings: [String: Int]

    init(rankings: [String: Int] = [:]) {
        self.rankings = rankings
    }

    /// The ranking for a stat or team name, or ``unranked`` when the payload has none.
    func ranking(for name: String) -> Int {
        rankings[name] ?? Self.unranked
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: RankingKey.self)

        var rankings: [String: Int] = [:]
        for key in container.allKeys {
            // Skip the payload's one string field; it names the row rather than ranking it.
            guard let ranking = try? container.decode(Int.self, forKey: key) else { continue }
            rankings[key.stringValue] = ranking
        }

        self.rankings = rankings
    }

    /// The API's keys are team and stat names, which are only known at runtime.
    private struct RankingKey: CodingKey {
        let stringValue: String
        var intValue: Int? { nil }

        init?(stringValue: String) { self.stringValue = stringValue }
        init?(intValue: Int) { return nil }
    }
}
