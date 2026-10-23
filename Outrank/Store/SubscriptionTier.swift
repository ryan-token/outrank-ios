//
//  SubscriptionTier.swift
//  Outrank
//
//  Created by Ryan Token on 10/17/21.
//

import Foundation

/// Subscription levels in ascending order, for picking the highest one a user holds.
nonisolated enum SubscriptionTier: Int, Comparable {
    case none = 0
    case small = 1
    case medium = 2
    case large = 3
    case giant = 4

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
