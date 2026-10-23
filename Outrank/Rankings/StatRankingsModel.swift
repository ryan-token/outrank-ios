//
//  StatRankingsModel.swift
//  Outrank
//
//  Created by Ryan Token on 10/4/21.
//

import Foundation
import OSLog

/// Loads every team's ranking in one stat, ordered best to worst.
@Observable
final class StatRankingsModel {
    private(set) var entries: [RankingEntry] = []
    private(set) var loadFailed = false

    /// Changes whenever `entries` does, giving views a cheap value to animate on.
    private(set) var revision = 0

    @ObservationIgnored private let fetch: (String) async throws -> RankingsResponse

    private static let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "StatRankingsModel")

    init(fetch: @escaping (String) async throws -> RankingsResponse = RankingsAPI.statRankings(for:)) {
        self.fetch = fetch
    }

    func load(stat: String) async {
        do {
            let response = try await fetch(stat)
            guard !Task.isCancelled else { return }
            let unsorted = response.rankings.map { teamKey, ranking in
                RankingEntry(id: teamKey, title: AllTeams.name(forAPIKey: teamKey), ranking: ranking)
            }
            entries = SortMethod.byRankingAscending.sorted(unsorted)
            loadFailed = false
            revision += 1
        } catch {
            guard !Task.isCancelled else { return }
            Self.logger.error("Failed to load rankings for \(stat, privacy: .public): \(error.localizedDescription)")
            loadFailed = true
        }
    }
}
