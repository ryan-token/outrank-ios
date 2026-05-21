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

    private var uniqueTeams: [String] {
        var seen = Set<String>()
        return favorites.compactMap { seen.insert($0.team).inserted ? $0.team : nil }
    }

    private var summary: String {
        let teams = uniqueTeams
        if teams.count == 1 {
            return teams[0]
        } else {
            return "\(teams.count) Teams"
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
