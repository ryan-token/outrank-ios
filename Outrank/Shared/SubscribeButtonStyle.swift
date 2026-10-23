//
//  SubscribeButtonStyle.swift
//  Outrank
//
//  Created by Ryan Token on 10/3/21.
//

import SwiftUI

/// The price button on the Subscriptions page; bright green once purchased.
struct SubscribeButtonStyle: ButtonStyle {
    var isPurchased = false

    @ScaledMetric(relativeTo: .body) private var minimumWidth = 50

    func makeBody(configuration: Configuration) -> some View {
        let baseColor: Color = isPurchased ? .green : .somewhatLighterDarkGreen

        configuration.label
            // A minimum rather than a fixed width, so longer local prices and larger
            // Dynamic Type sizes widen the button instead of truncating the price.
            .frame(minWidth: minimumWidth)
            .padding(10)
            .background(configuration.isPressed ? baseColor.opacity(0.7) : baseColor)
            .clipShape(.rect(cornerRadius: 20))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

extension ButtonStyle where Self == SubscribeButtonStyle {
    static func subscribe(isPurchased: Bool) -> SubscribeButtonStyle {
        SubscribeButtonStyle(isPurchased: isPurchased)
    }
}
