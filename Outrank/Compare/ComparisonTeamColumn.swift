//
//  ComparisonTeamColumn.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

/// One compared team with its simple average beneath it, so the two stay together
/// whether the header lays the teams out side by side or stacked.
struct ComparisonTeamColumn: View {
    let team: String
    let average: Int?
    let slot: ComparisonSlot
    let alignment: HorizontalAlignment
    @Binding var presentedPicker: ComparisonSlot?

    private var textAlignment: TextAlignment {
        switch alignment {
        case .leading: .leading
        case .trailing: .trailing
        default: .center
        }
    }

    /// A team not ranked in anything yet has no average; say so rather than leaving a
    /// bare "Simple Average: " that VoiceOver reads as empty.
    private var formattedAverage: String {
        average?.formatted() ?? String(localized: "Unknown")
    }

    var body: some View {
        VStack(alignment: alignment) {
            ComparisonTeamButton(team: team, slot: slot, presentedPicker: $presentedPicker)

            Text("Simple Average: \(formattedAverage)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(textAlignment)
                .accessibilityLabel("\(team)'s Average Ranking: \(formattedAverage)")
        }
        .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment, vertical: .top))
    }
}
