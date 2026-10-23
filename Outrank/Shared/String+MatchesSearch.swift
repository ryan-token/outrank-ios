//
//  String+MatchesSearch.swift
//  Outrank
//

import Foundation

nonisolated extension String {
    /// Whether this string matches text typed into a search field. Ignores case and
    /// diacritics and surrounding spaces, and an empty search matches everything.
    func matchesSearch(_ searchText: String) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        return query.isEmpty || localizedStandardContains(query)
    }
}
