//
//  TeamRankingsEntry.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 9/4/26.
//

import WidgetKit

nonisolated struct TeamRankingsEntry: TimelineEntry {
    let date: Date

    /// Carried on the entry rather than read by the view, so the name on screen always
    /// describes the rankings alongside it — even if the user picks a different team
    /// before WidgetKit asks for a new timeline.
    let team: String

    let rankings: [String: Int]
}
