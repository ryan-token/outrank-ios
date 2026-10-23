//
//  ComparisonTeamColumn.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

/// One compared team with its simple average beneath it.
struct ComparisonTeamColumn: View {
    let team: String
    let average: Int?
    let isLoading: Bool
    let slot: ComparisonSlot
    let alignment: HorizontalAlignment
    @Binding var presentedPicker: ComparisonSlot?

    /// The gap above and below the average, so it sits evenly between its team's button
    /// and the list.
    @ScaledMetric(relativeTo: .subheadline) private var averageSpacing = 12

    private var textAlignment: TextAlignment {
        switch alignment {
        case .leading: .leading
        case .trailing: .trailing
        default: .center
        }
    }

    /// While loading, a typical three-digit value that the redacted placeholder sizes
    /// itself to, so the real average lands in the space already laid out for it. A team
    /// not ranked in anything has no average; say so rather than leaving a bare
    /// "Simple Average: " that VoiceOver reads as empty.
    private var formattedAverage: String {
        if isLoading {
            100.formatted()
        } else {
            average?.formatted() ?? String(localized: "Unknown")
        }
    }

    private var accessibilityAverage: String {
        isLoading ? String(localized: "Loading") : formattedAverage
    }

    var body: some View {
        VStack(alignment: alignment, spacing: averageSpacing) {
            ComparisonTeamButton(team: team, slot: slot, presentedPicker: $presentedPicker)

            Text("Simple Average: \(formattedAverage)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(textAlignment)
                .redacted(reason: isLoading ? .placeholder : [])
                // Digits roll to the new value, on first load and when the teams swap.
                .contentTransition(.numericText(value: Double(average ?? 0)))
                .animation(.smooth, value: average)
                .animation(.smooth, value: isLoading)
                .accessibilityLabel("\(team)'s Average Ranking: \(accessibilityAverage)")
        }
        .padding(.bottom, averageSpacing)
        .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment, vertical: .top))
    }
}
