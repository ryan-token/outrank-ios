//
//  ComparisonLoadKey.swift
//  Outrank
//

import Foundation

/// What the Compare screen checks for stale rankings on: either team changing, or the
/// app returning to the foreground after possibly sitting in the background for days.
struct ComparisonLoadKey: Hashable {
    let teamOne: String
    let teamTwo: String
    let isActive: Bool
}
