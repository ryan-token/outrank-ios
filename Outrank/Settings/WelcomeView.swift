//
//  WelcomeView.swift
//  Outrank
//

import SwiftUI

enum WelcomeViewType {
    case rankings
    case settings

    var prompt: LocalizedStringResource {
        switch self {
        case .rankings: "Select a stat from the left-hand menu; swipe from the left edge to show it."
        case .settings: "Select a setting from the left-hand menu; swipe from the left edge to show it."
        }
    }
}

/// Placeholder shown in the detail column of `NavigationSplitView` on iPad
/// before the user has made a selection from the sidebar.
struct WelcomeView: View {
    let type: WelcomeViewType

    var body: some View {
        VStack(spacing: 20) {
            Image("Outrank")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(.rect(cornerRadius: 20))

            Text("Welcome to Outrank!")
                .font(.largeTitle)

            Text(type.prompt)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

#Preview {
    WelcomeView(type: .rankings)
}
