//
//  SettingsRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: LocalizedStringResource
    var showsExternalIndicator: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(iconColor)

            Text(title)
                .foregroundStyle(.primary)

            if showsExternalIndicator {
                Spacer()
                Image(systemName: "arrow.up.forward")
                    .foregroundStyle(.tertiary)
                    .font(.headline)
            }
        }
    }
}
