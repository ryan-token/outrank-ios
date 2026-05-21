//
//  ComparisonHeader.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonHeader: View {
    let teamOne: String
    let teamTwo: String
    let onChooseTeamOne: () -> Void
    let onChooseTeamTwo: () -> Void
    let onSwap: () -> Void

    var body: some View {
        HStack {
            Button(teamOne, action: onChooseTeamOne)
                .buttonStyle(GrowingButton())
                .accessibilityLabel("\(teamOne), Change Team One")

            Spacer()

            Button("Swap Teams", systemImage: "arrow.left.arrow.right.square", action: onSwap)
                .labelStyle(.iconOnly)
                .font(.title)
                .foregroundStyle(.green)

            Spacer()

            Button(teamTwo, action: onChooseTeamTwo)
                .buttonStyle(GrowingButton())
                .accessibilityLabel("\(teamTwo), Change Team Two")
        }
        .padding(.top, 5)
        .padding(.horizontal, 25)
    }
}
