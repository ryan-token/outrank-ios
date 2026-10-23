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
        LabeledContent {
            if showsExternalIndicator {
                Image(systemName: "arrow.up.forward")
                    .foregroundStyle(.tertiary)
                    .font(.headline)
                    .accessibilityHidden(true)
            }
        } label: {
            SettingsLabel(title: title, icon: icon, iconColor: iconColor)
        }
    }
}
