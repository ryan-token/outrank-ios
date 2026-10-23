//
//  GrowingButtonStyle.swift
//  Outrank
//
//  Created by Ryan Token on 10/3/21.
//

import SwiftUI

/// A filled green capsule that grows slightly while pressed. Used for the team buttons
/// on the Compare page.
struct GrowingButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding()
            .background(colorScheme == .light ? Color.evenLighterDarkGreen : Color.somewhatLighterDarkGreen)
            .foregroundStyle(colorScheme == .light ? Color.white : Color.lighterGray)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: colorScheme == .light ? .gray : .black, radius: 5, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == GrowingButtonStyle {
    static var growing: GrowingButtonStyle { GrowingButtonStyle() }
}
