//
//  RankingEntry.swift
//  Outrank
//

import Foundation

/// One row of rankings: a stat with the selected team's ranking in it, or a team with its
/// ranking in one stat.
///
/// Built once when rankings load or the sort order changes, so rows can display it
/// without recomputing names or lookups during view updates.
nonisolated struct RankingEntry: Identifiable, Equatable, Sendable {
    /// The API key for the row: a stat name or a team key. Stable across reloads, so it
    /// identifies the row in lists and navigation.
    let id: String

    /// The human-readable name shown in the row.
    let title: String

    let ranking: Int
}
