//
//  TeamSearch.swift
//  Outrank
//

import Foundation

/// The search text for a team list and the teams matching it, recomputed only when the
/// text changes rather than on every view update.
@Observable
final class TeamSearch {
    var text = "" {
        didSet {
            matchingTeams = AllTeams.all.filter { $0.name.matchesSearch(text) }
            // Stored rather than computed, so views that only check it update when
            // searching starts or stops, not on every keystroke.
            isSearching = !text.isEmpty
        }
    }

    private(set) var matchingTeams = AllTeams.all
    private(set) var isSearching = false

    /// Whether a team outside `AllTeams`, such as a stored favorite, matches the search.
    func matches(_ team: String) -> Bool {
        team.matchesSearch(text)
    }
}
