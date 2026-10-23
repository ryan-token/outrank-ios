//
//  WelcomeView.swift
//  Outrank
//

import SwiftUI

/// Placeholder shown in a split view's detail column, such as on iPad or iPhone Duo's
/// inner display, until the user picks something from the sidebar.
struct WelcomeView: View {
    let type: WelcomeViewType

    var body: some View {
        ContentUnavailableView {
            Label("Welcome to Outrank!", systemImage: type.systemImage)
        } description: {
            Text(type.prompt)
        }
        // Matches the detail screens' grouped lists, which SwiftUI has no style for.
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

#Preview {
    WelcomeView(type: .rankings)
}
