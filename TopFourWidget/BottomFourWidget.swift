//
//  BottomFourWidget.swift
//  BottomFourWidgetExtension
//
//  Created by Ryan Token on 10/15/21.
//

import WidgetKit
import SwiftUI

struct BottomFourWidget: Widget {
    let kind: String = "BottomFourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TeamRankingsProvider()) { entry in
            TopOrBottomFourView(type: .bottomFour, team: entry.team, rankings: entry.rankings)
        }
        .configurationDisplayName("Bottom Four Widget")
        .description("A team's bottom four stats. Change the team in the app's Settings page.")
        .supportedFamilies([.systemMedium])
    }
}
