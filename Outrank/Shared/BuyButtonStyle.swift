//
//  BuyButtonStyle.swift
//  Outrank
//
//  Created by Ryan Token on 10/3/21.
//

import SwiftUI

/// The green price button on the Tip Jar page.
struct BuyButtonStyle: ButtonStyle {
    @ScaledMetric(relativeTo: .body) private var minimumWidth = 50

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // A minimum rather than a fixed width, so longer local prices and larger
            // Dynamic Type sizes widen the button instead of truncating the price.
            .frame(minWidth: minimumWidth)
            .padding(10)
            .background(configuration.isPressed ? Color.green.opacity(0.7) : Color.green)
            .clipShape(.rect(cornerRadius: 20))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

extension ButtonStyle where Self == BuyButtonStyle {
    static var buy: BuyButtonStyle { BuyButtonStyle() }
}
