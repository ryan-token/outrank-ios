//
//  PriceButtonStyle.swift
//  Outrank
//
//  Created by Ryan Token on 10/3/21.
//

import SwiftUI

/// The rounded price button on the Tip Jar and Subscriptions pages.
struct PriceButtonStyle: ButtonStyle {
    let tint: Color

    @ScaledMetric(relativeTo: .body) private var minimumWidth = 50

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // A minimum rather than a fixed width, so longer local prices and larger
            // Dynamic Type sizes widen the button instead of truncating the price.
            .frame(minWidth: minimumWidth)
            .padding(10)
            .background(configuration.isPressed ? tint.opacity(0.7) : tint)
            .clipShape(.rect(cornerRadius: 20))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

extension ButtonStyle where Self == PriceButtonStyle {
    static var buy: PriceButtonStyle { PriceButtonStyle(tint: .green) }

    /// Bright green once purchased.
    static func subscribe(isPurchased: Bool) -> PriceButtonStyle {
        PriceButtonStyle(tint: isPurchased ? .green : .somewhatLighterDarkGreen)
    }
}
