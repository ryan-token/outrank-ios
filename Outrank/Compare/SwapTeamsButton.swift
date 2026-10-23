//
//  SwapTeamsButton.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct SwapTeamsButton: View {
    let model: ComparisonModel

    @ScaledMetric(relativeTo: .title) private var minimumTapSize = 44
    @State private var swapCount = 0

    var body: some View {
        Button("Swap Teams", systemImage: "arrow.left.arrow.right.square", action: swap)
            .labelStyle(.iconOnly)
            .font(.title)
            .foregroundStyle(.green)
            // The symbol alone is smaller than the 44-point minimum tap target.
            .frame(minWidth: minimumTapSize, minHeight: minimumTapSize)
            .contentShape(.rect)
            .sensoryFeedback(.selection, trigger: swapCount)
    }

    private func swap() {
        model.swapTeams()
        swapCount += 1
    }
}
