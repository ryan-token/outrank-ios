//
//  String+CamelCaseToWords.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

extension String {
    /// Inserts a space before every uppercase letter after the first, so "ScoringOffense"
    /// becomes "Scoring Offense".
    nonisolated func camelCaseToWords() -> String {
        var words = ""
        for character in self {
            if character.isUppercase, !words.isEmpty {
                words.append(" ")
            }
            words.append(character)
        }
        return words
    }
}
