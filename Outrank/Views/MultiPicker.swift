//
//  MultiPicker.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct MultiPicker: View {
    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    private var favorites: FetchedResults<Favorite>

    var body: some View {
        NavigationLink {
            MultiPickerView()
        } label: {
            HStack {
                FavoriteTeamsLabel()
                Spacer()
                Text(summary)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var summary: String {
        if favorites.count == 1 {
            favorites[0].wrappedTeam
        } else {
            "\(favorites.count) Teams"
        }
    }
}

struct FavoriteTeamsLabel: View {
    var body: some View {
        Label {
            Text("Favorites")
        } icon: {
            Image(systemName: "star.square.fill")
                .font(.title)
                .foregroundStyle(.yellow)
        }
    }
}
