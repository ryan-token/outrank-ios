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

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        // Chosen from the text size rather than measured, so the first layout pass on
        // launch can't briefly pick the stacked arrangement. Each team gets half the
        // width, so a long name wraps instead of crowding the swap button.
        let isStacked = dynamicTypeSize.isAccessibilitySize
        let layout = isStacked ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout(alignment: .top))

        layout {
            column(.teamOne, alignment: isStacked ? .center : .leading)
            SwapTeamsButton(model: model)
            column(.teamTwo, alignment: isStacked ? .center : .trailing)
        }
        .padding([.horizontal, .bottom])
    }

    private func column(_ slot: ComparisonSlot, alignment: HorizontalAlignment) -> ComparisonTeamColumn {
        ComparisonTeamColumn(
            team: model[team: slot],
            average: slot == .teamOne ? model.teamOneAverage : model.teamTwoAverage,
            slot: slot,
            alignment: alignment,
            presentedPicker: $presentedPicker
        )
    }
}
