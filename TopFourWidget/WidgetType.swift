//
//  WidgetType.swift
//  TopFourWidgetExtension
//
//  Created by Ryan Token on 10/9/21.
//

import SwiftUI

enum WidgetType {
    case topFour
    case bottomFour

    func title(for team: String) -> String {
        switch self {
        case .topFour: "\(team)'s Top Four"
        case .bottomFour: "\(team)'s Bottom Four"
        }
    }

    var rankingColor: Color {
        switch self {
        case .topFour: .green
        case .bottomFour: .red
        }
    }
}
