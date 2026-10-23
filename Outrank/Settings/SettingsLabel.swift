//
//  SettingsLabel.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

/// A Settings title with its colored icon. Every row uses it, so the icons share one
/// size and the separators line up.
struct SettingsLabel: View {
    let title: LocalizedStringResource
    let icon: String
    let iconColor: Color

    var body: some View {
        Label {
            Text(title)
                .foregroundStyle(.primary)
        } icon: {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(iconColor)
        }
    }
}
