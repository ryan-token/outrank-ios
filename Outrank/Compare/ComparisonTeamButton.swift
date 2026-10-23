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

    private var accessibilityAction: LocalizedStringResource {
        switch slot {
        case .teamOne: "Change Team One"
        case .teamTwo: "Change Team Two"
        }
    }

    var body: some View {
        Button(team, action: choose)
            .buttonStyle(.growing)
            .accessibilityLabel("\(team), \(accessibilityAction)")
            .accessibilityInputLabels([Text(team), Text(accessibilityAction)])
    }

    private func choose() {
        presentedPicker = slot
    }
}
