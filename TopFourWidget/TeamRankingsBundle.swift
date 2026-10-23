//
//  TeamRankingsBundle.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/3/21.
//

import SwiftUI
import WidgetKit

@main
struct TeamRankingsBundle: WidgetBundle {
    var body: some Widget {
        TopFourWidget()
        BottomFourWidget()
    }
}
