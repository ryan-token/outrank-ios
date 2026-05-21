//
//  TeamPickerRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct TeamPickerRow: View {
    let team: String
    let isFavorite: Bool

    var body: some View {
        Text(team)
            .font(isFavorite ? .headline : .body)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect)
    }
}
