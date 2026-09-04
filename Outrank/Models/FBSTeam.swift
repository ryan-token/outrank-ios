//
//  FBSTeam.swift
//  Outrank
//
//  Created by Ryan Token on 9/4/26.
//

import Foundation

/// One FBS program, as the rankings backend knows it.
nonisolated struct FBSTeam: Identifiable, Hashable, Sendable {
    /// The name ncaa.com uses, which is also the key the API stores the team's own
    /// rankings under.
    let name: String

    /// The attribute name the API uses for this team inside a single stat's rankings.
    /// Usually the name with punctuation and spaces removed, but not always.
    let apiKey: String

    var id: String { apiKey }
}
