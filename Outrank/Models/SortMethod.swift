//
//  SortMethod.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

nonisolated enum SortMethod: String, CaseIterable, Identifiable {
    case byStatAlphabetically
    case byStatReverseAlphabetically
    case byRankingAscending
    case byRankingDescending

    var id: String { rawValue }

    /// Short, team-agnostic label used in the sort picker menu.
    var menuLabel: String {
        sectionLabel(rankingPrefix: nil)
    }

    /// Section-header label. Pass a team name to scope ranking-based labels to
    /// that team (used on the Compare page, where rankings refer to team one).
    func sectionLabel(rankingPrefix: String? = nil) -> String {
        let prefix = rankingPrefix.map { "\($0) " } ?? ""
        return switch self {
        case .byStatAlphabetically: "Stat (A → Z)"
        case .byStatReverseAlphabetically: "Stat (Z → A)"
        case .byRankingAscending: "\(prefix)Ranking (best → worst)"
        case .byRankingDescending: "\(prefix)Ranking (worst → best)"
        }
    }

    /// Orders entries for display. Ties in ranking fall back to the entry's key so the
    /// order is deterministic and rows don't shuffle between reloads.
    func sorted(_ entries: [RankingEntry]) -> [RankingEntry] {
        switch self {
        case .byStatAlphabetically:
            entries.sorted { $0.id < $1.id }
        case .byStatReverseAlphabetically:
            entries.sorted { $0.id > $1.id }
        case .byRankingAscending:
            entries.sorted { ($0.ranking, $0.id) < ($1.ranking, $1.id) }
        case .byRankingDescending:
            entries.sorted { ($0.ranking, $1.id) > ($1.ranking, $0.id) }
        }
    }
}
