//
//  ComparisonTeamButton.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

/// Shows one compared team and opens the team picker for its slot.
struct ComparisonTeamButton: View {
    let team: String
    let slot: ComparisonSlot
    @Binding var presentedPicker: ComparisonSlot?

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var accessibilityAction: LocalizedStringResource {
        switch slot {
        case .teamOne: "Change Team One"
        case .teamTwo: "Change Team Two"
        }
    }

    var body: some View {
        let lineCount = dynamicTypeSize.isAccessibilitySize ? 2 : 1

        Button(action: choose) {
            // Both buttons fill their half of the header and reserve the same number of
            // lines, so they match in size whatever the names; the hidden copy reserves
            // the space and the visible name is centred in it. A long name shrinks a
            // little rather than wrapping, and at accessibility sizes it gets two lines.
            Text(team)
                .lineLimit(lineCount, reservesSpace: true)
                .hidden()
                .overlay {
                    Text(team)
                        .lineLimit(lineCount)
                        .minimumScaleFactor(0.7)
                }
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.growing)
        .accessibilityLabel("\(team), \(accessibilityAction)")
        .accessibilityInputLabels([Text(team), Text(accessibilityAction)])
    }

    private func choose() {
        presentedPicker = slot
    }
}
