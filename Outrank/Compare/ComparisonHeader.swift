//
//  ComparisonHeader.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

/// The two compared teams and their averages, each tappable to change it, with a swap
/// control between them.
struct ComparisonHeader: View {
    let model: ComparisonModel
    @Binding var presentedPicker: ComparisonSlot?

    var body: some View {
        // Side by side at every text size, so the header never crowds out the list. Each
        // team gets half the width, so a long name wraps instead of pushing the swap button.
        HStack(alignment: .top) {
            ComparisonTeamColumn(
                team: model.teamOne,
                average: model.teamOneAverage,
                isLoading: model.isAwaitingFirstLoad(.teamOne),
                slot: .teamOne,
                alignment: .leading,
                presentedPicker: $presentedPicker
            )

            SwapTeamsButton(model: model)

            ComparisonTeamColumn(
                team: model.teamTwo,
                average: model.teamTwoAverage,
                isLoading: model.isAwaitingFirstLoad(.teamTwo),
                slot: .teamTwo,
                alignment: .trailing,
                presentedPicker: $presentedPicker
            )
        }
        // Each column adds its own bottom spacing, matching the gap above its average.
        .padding(.horizontal)
    }
}
