//
//  AboutHeader.swift
//  Outrank
//
//  Created by Ryan Token on 10/6/21.
//

import SwiftUI

struct AboutHeader: View {
    @ScaledMetric(relativeTo: .largeTitle) private var iconSize = 100

    var body: some View {
        VStack {
            Image(.outrank)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .clipShape(.rect(cornerRadius: iconSize / 5))
                .accessibilityHidden(true)

            Text("Outrank")
                .font(.largeTitle)
                .bold()

            Text("Made with ❤️ by an independent developer")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityLabel("Made with love by an independent developer")
        }
        .frame(maxWidth: .infinity)
    }
}
