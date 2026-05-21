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

    func sort(_ rankings: [String: Int]) -> [(key: String, value: Int)] {
        switch self {
        case .byStatAlphabetically: rankings.sorted { $0.key < $1.key }
        case .byStatReverseAlphabetically: rankings.sorted { $0.key > $1.key }
        case .byRankingAscending: rankings.sorted { $0.value < $1.value }
        case .byRankingDescending: rankings.sorted { $0.value > $1.value }
        }
    }
}
