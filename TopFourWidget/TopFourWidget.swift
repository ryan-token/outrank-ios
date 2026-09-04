//
//  TopFourWidget.swift
//  TopFourWidget
//
//  Created by Ryan Token on 10/3/21.
//

import WidgetKit
import SwiftUI

struct TopFourWidget: Widget {
    let kind: String = "TopFourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TeamRankingsProvider()) { entry in
            TopOrBottomFourView(type: .topFour, team: entry.team, rankings: entry.rankings)
        }
        .configurationDisplayName("Top Four Widget")
        .description("A team's top four stats. Change the team in the app's Settings page.")
        .supportedFamilies([.systemMedium])
    }
}

@main
struct TeamRankingsBundle: WidgetBundle {
    var body: some Widget {
        TopFourWidget()
        BottomFourWidget()
    }
}
