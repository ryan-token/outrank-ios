//
//  TeamRankingsModel.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation
import OSLog

/// Loads one team's ranking in every stat and keeps them sorted for display.
///
/// Sorting happens here, when the rankings or the sort order change, rather than in a
/// view's `body`, which SwiftUI can evaluate far more often than either changes.
@Observable
final class TeamRankingsModel {
    static let teamKey = "CurrentTeam"
    static let defaultTeam = "Air Force"

    /// The team being shown. Persisted so the app reopens on the same team.
    var team: String {
        didSet {
            guard team != oldValue else { return }
            defaults.set(team, forKey: Self.teamKey)
            // Drop the previous team's rankings so they never show under the new name.
            rankings = [:]
            loadFailed = false
            resort()
        }
    }

    var sortMethod: SortMethod = .byStatAlphabetically {
        didSet { resort() }
    }

    private(set) var rankings: [String: Int] = [:]
    private(set) var sortedRankings: [RankingEntry] = []
    private(set) var loadFailed = false

    /// Changes whenever `sortedRankings` does. Views animate on this rather than on the
    /// rankings themselves, which would be compared element by element on every update.
    private(set) var revision = 0

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let fetch: (String) async throws -> RankingsResponse

    private static let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "TeamRankingsModel")

    init(
        defaults: UserDefaults = .standard,
        fetch: @escaping (String) async throws -> RankingsResponse = RankingsAPI.teamRankings(for:)
    ) {
        self.defaults = defaults
        self.fetch = fetch
        team = defaults.string(forKey: Self.teamKey) ?? Self.defaultTeam
    }

    /// The team's ranking in a stat, or ``RankingsResponse/unranked`` when it has none.
    func ranking(forStat stat: String) -> Int {
        rankings[stat] ?? RankingsResponse.unranked
    }

    /// Fetches the current team's rankings.
    /// - Returns: Whether the rankings loaded and are now on screen.
    @discardableResult
    func load() async -> Bool {
        let requestedTeam = team

        do {
            let response = try await fetch(requestedTeam)
            // The team may have changed while this request was in flight; its own load
            // will supply the rankings.
            guard !Task.isCancelled, requestedTeam == team else { return false }
            rankings = response.rankings
            loadFailed = false
            resort()
            return true
        } catch {
            guard !Task.isCancelled, requestedTeam == team else { return false }
            Self.logger.error(
                "Failed to load rankings for \(requestedTeam, privacy: .public): \(error.localizedDescription)"
            )
            loadFailed = true
            return false
        }
    }

    private func resort() {
        let entries = rankings.map { stat, ranking in
            RankingEntry(id: stat, title: Conversions.humanReadableStat(for: stat), ranking: ranking)
        }
        sortedRankings = sortMethod.sorted(entries)
        revision += 1
    }
}
