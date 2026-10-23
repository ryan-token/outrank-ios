//
//  InfoSource.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import Foundation

/// The page an ``InfoView`` explains, since each page uses the colors differently.
enum InfoSource {
    case rankings
    case compare

    var greenDescription: LocalizedStringResource {
        switch self {
        case .rankings: "means the team ranks in the *top half* of the country."
        case .compare: "means the team ranks *better* on a given stat than the team you're comparing them with."
        }
    }

    var redDescription: LocalizedStringResource {
        switch self {
        case .rankings: "means the team ranks in the *bottom half*."
        case .compare: "means the team ranks *worse* than the other team."
        }
    }

    /// Both pages use the same neutral tint for a team with no ranking in a stat.
    var greyDescription: LocalizedStringResource {
        "means the team isn't ranked in that stat yet."
    }

    var heading: LocalizedStringResource {
        switch self {
        case .rankings: "Rankings page colors"
        case .compare: "Compare page colors"
        }
    }

    var otherPageNote: LocalizedStringResource {
        switch self {
        case .rankings: "The colors work differently on the **Compare** page."
        case .compare: "The colors work differently on the **Rankings** page."
        }
    }
}
