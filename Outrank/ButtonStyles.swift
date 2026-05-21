//
//  ButtonStyles.swift
//  Outrank
//
//  Created by Ryan Token on 10/3/21.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(colorScheme == .light ? Color.evenLighterDarkGreen : Color.somewhatLighterDarkGreen)
            .foregroundStyle(colorScheme == .light ? Color.white : Color.lighterGray)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: colorScheme == .light ? .gray : .black, radius: 5, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct BuyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let bgColor = configuration.isPressed ? Color.green.opacity(0.7) : Color.green

        return configuration.label
            .frame(width: 50)
            .padding(10)
            .background(bgColor)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

struct SubscribeButtonStyle: ButtonStyle {
    var isPurchased: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        let baseColor: Color = isPurchased ? .green : .somewhatLighterDarkGreen
        let bgColor = configuration.isPressed ? baseColor.opacity(0.7) : baseColor

        return configuration.label
            .frame(width: 50)
            .padding(10)
            .background(bgColor)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
