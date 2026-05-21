//
//  String+CamelCaseToWords.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

extension String {
    nonisolated func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0.count > 0 {
                    return ($0 + " " + String($1))
                }
            }
            return $0 + String($1)
        }
    }
}
