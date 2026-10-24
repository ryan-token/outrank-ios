//
//  OtherAppRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/6/21.
//

import SwiftUI

struct OtherAppRow: View {
    let image: ImageResource
    let title: String
    let subtitle: String

    @ScaledMetric(relativeTo: .headline) private var iconSize = 60

    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .clipShape(.rect(cornerRadius: iconSize * 11 / 60))
                .accessibilityHidden(true)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(.rect)
    }
}
