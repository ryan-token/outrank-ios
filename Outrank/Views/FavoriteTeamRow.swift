//
//  FavoriteTeamRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct FavoriteTeamRow: View {
    let team: String
    let isFavorite: Bool

    var body: some View {
        HStack {
            Text(team)
                .font(isFavorite ? .headline : .body)
                .foregroundStyle(.primary)

            Spacer()

            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundStyle(.yellow)
        }
        .contentShape(.rect)
    }
}
