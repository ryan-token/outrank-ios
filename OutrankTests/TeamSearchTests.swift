//
//  TeamSearchTests.swift
//  OutrankTests
//

import Testing
@testable import Outrank

struct TeamSearchTests {
    @Test func emptySearchShowsEveryTeam() {
        let search = TeamSearch()
        search.text = "Tulsa"
        search.text = ""

        #expect(search.matchingTeams == AllTeams.all)
        #expect(search.matches("Any Favorite"))
    }

    @Test(arguments: [
        ("texas a&m", ["Texas A&M"]),
        ("  miami  ", ["Miami (FL)", "Miami (OH)"]),
        ("San José", ["San Jose St."])
    ])
    func searchIgnoresCaseDiacriticsAndSurroundingSpaces(text: String, expected: [String]) {
        let search = TeamSearch()
        search.text = text
        #expect(search.matchingTeams.map(\.name) == expected)
    }

    @Test func searchWithNoMatchesIsEmpty() {
        let search = TeamSearch()
        search.text = "Zzz"
        #expect(search.matchingTeams.isEmpty)
        #expect(!search.matches("Tulsa"))
    }
}
