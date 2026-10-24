//
//  ComparisonSlot.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

/// Which of the two compared teams something refers to.
nonisolated enum ComparisonSlot: String, Identifiable, Sendable {
    case teamOne
    case teamTwo

    var id: String { rawValue }
}
