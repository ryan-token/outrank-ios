//
//  ComparisonModel.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation
import OSLog

/// Loads two teams' rankings and lines them up stat by stat.
@Observable
final class ComparisonModel {
    static let teamOneKey = "TeamOne"
    static let teamTwoKey = "TeamTwo"

    /// How long loaded rankings stay current. The rankings change at most daily, so an
    /// hour avoids refetching on every tab switch without letting a long-lived session
    /// fall behind an update.
    static let maxRankingsAge: TimeInterval = 60 * 60

    /// Persisted so the comparison reopens on the same teams. Set through
    /// `subscript(team:)` or `swapTeams()`, which keep each slot's rankings in step.
    private(set) var teamOne: String {
        didSet { defaults.set(teamOne, forKey: Self.teamOneKey) }
    }

    private(set) var teamTwo: String {
        didSet { defaults.set(teamTwo, forKey: Self.teamTwoKey) }
    }

    /// Orders rows by stat name, or by team one's ranking.
    var sortMethod: SortMethod = .byStatAlphabetically {
        didSet { rebuildRows() }
    }

    private(set) var teamOneRankings: [String: Int] = [:]
    private(set) var teamTwoRankings: [String: Int] = [:]
    private(set) var rows: [ComparisonEntry] = []
    private(set) var teamOneAverage: Int?
    private(set) var teamTwoAverage: Int?
    private(set) var teamOneLoadFailed = false
    private(set) var teamTwoLoadFailed = false

    /// Changes whenever `rows` does, giving views a cheap value to animate on.
    private(set) var revision = 0

    var loadFailed: Bool {
        teamOneLoadFailed || teamTwoLoadFailed
    }

    /// Whether a slot's team is still waiting for its first rankings, as opposed to
    /// loaded or failed. Refreshing already-loaded rankings doesn't count.
    func isAwaitingFirstLoad(_ slot: ComparisonSlot) -> Bool {
        switch slot {
        case .teamOne: teamOneLoadedAt == nil && !teamOneLoadFailed
        case .teamTwo: teamTwoLoadedAt == nil && !teamTwoLoadFailed
        }
    }

    /// When each slot's rankings last arrived; `nil` until its current team first loads.
    private var teamOneLoadedAt: Date?
    private var teamTwoLoadedAt: Date?

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private let fetch: (String) async throws -> RankingsResponse
    @ObservationIgnored private let now: () -> Date

    private static let logger = Logger(category: "ComparisonModel")

    init(
        defaults: UserDefaults = .standard,
        fetch: @escaping (String) async throws -> RankingsResponse = RankingsAPI.teamRankings(for:),
        now: @escaping () -> Date = Date.init
    ) {
        self.defaults = defaults
        self.now = now
        self.fetch = fetch
        teamOne = defaults.string(forKey: Self.teamOneKey) ?? "Tulsa"
        teamTwo = defaults.string(forKey: Self.teamTwoKey) ?? "SMU"
    }

    /// The team in a slot. Writable, so a picker can bind straight to `$model[team: slot]`.
    /// Picking a new team drops the slot's old rankings so they never show under its name.
    subscript(team slot: ComparisonSlot) -> String {
        get {
            switch slot {
            case .teamOne: teamOne
            case .teamTwo: teamTwo
            }
        }
        set {
            guard newValue != self[team: slot] else { return }
            switch slot {
            case .teamOne: teamOne = newValue
            case .teamTwo: teamTwo = newValue
            }
            apply([:], to: slot, loadedAt: nil)
        }
    }

    /// Exchanges the two teams, carrying their already-loaded rankings across so the
    /// screen updates immediately.
    func swapTeams() {
        (teamOne, teamTwo) = (teamTwo, teamOne)
        (teamOneRankings, teamTwoRankings) = (teamTwoRankings, teamOneRankings)
        (teamOneAverage, teamTwoAverage) = (teamTwoAverage, teamOneAverage)
        (teamOneLoadFailed, teamTwoLoadFailed) = (teamTwoLoadFailed, teamOneLoadFailed)
        (teamOneLoadedAt, teamTwoLoadedAt) = (teamTwoLoadedAt, teamOneLoadedAt)
        rebuildRows()
    }

    func loadBothTeams() async {
        async let teamOneLoad: Void = load(.teamOne)
        async let teamTwoLoad: Void = load(.teamTwo)
        _ = await (teamOneLoad, teamTwoLoad)
    }

    /// Loads each team whose rankings are missing, failed, or older than `maxRankingsAge`.
    /// Teams still current, such as both teams right after a swap, aren't fetched again.
    func loadStaleTeams() async {
        async let teamOneLoad: Void = loadIfStale(.teamOne)
        async let teamTwoLoad: Void = loadIfStale(.teamTwo)
        _ = await (teamOneLoad, teamTwoLoad)
    }

    private func loadIfStale(_ slot: ComparisonSlot) async {
        let (loadedAt, loadFailed) = switch slot {
        case .teamOne: (teamOneLoadedAt, teamOneLoadFailed)
        case .teamTwo: (teamTwoLoadedAt, teamTwoLoadFailed)
        }

        if let loadedAt, !loadFailed, now().timeIntervalSince(loadedAt) < Self.maxRankingsAge {
            return
        }
        await load(slot)
    }

    func load(_ slot: ComparisonSlot) async {
        let requestedTeam = self[team: slot]

        do {
            let response = try await fetch(requestedTeam)
            // The slot may hold a different team by now, after a swap or a new pick.
            guard !Task.isCancelled, requestedTeam == self[team: slot] else { return }
            apply(response.rankings, to: slot, loadedAt: now())
        } catch {
            guard !Task.isCancelled, requestedTeam == self[team: slot] else { return }
            Self.logger.error(
                "Failed to load rankings for \(requestedTeam, privacy: .public): \(String(describing: error))"
            )
            switch slot {
            case .teamOne: teamOneLoadFailed = true
            case .teamTwo: teamTwoLoadFailed = true
            }
        }
    }

    private func apply(_ rankings: [String: Int], to slot: ComparisonSlot, loadedAt: Date?) {
        let average = RankingStatistics.simpleAverage(of: rankings)

        switch slot {
        case .teamOne:
            teamOneRankings = rankings
            teamOneAverage = average
            teamOneLoadFailed = false
            teamOneLoadedAt = loadedAt
        case .teamTwo:
            teamTwoRankings = rankings
            teamTwoAverage = average
            teamTwoLoadFailed = false
            teamTwoLoadedAt = loadedAt
        }

        rebuildRows()
    }

    private func rebuildRows() {
        let teamOneEntries = teamOneRankings.map { stat, ranking in
            RankingEntry(id: stat, title: Conversions.humanReadableStat(for: stat), ranking: ranking)
        }

        rows = sortMethod.sorted(teamOneEntries).map { entry in
            ComparisonEntry(
                id: entry.id,
                title: entry.title,
                teamOneRanking: entry.ranking,
                teamTwoRanking: teamTwoRankings[entry.id] ?? RankingsResponse.unranked
            )
        }
        revision += 1
    }
}
