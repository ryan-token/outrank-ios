//
//  InfoView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

/// Explains what the ranking colors mean on the page that presented it.
struct InfoView: View {
    @Environment(\.dismiss) private var dismiss

    let source: InfoSource

    var body: some View {
        NavigationStack {
            // Scrolls so the explanation stays reachable at large Dynamic Type sizes and on
            // short windows, such as iPhone Duo's outer display in landscape.
            ScrollView {
                InfoExplanation(source: source)
            }
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close, action: dismiss.callAsFunction)
                }
            }
        }
    }
}

#Preview {
    InfoView(source: .rankings)
}
