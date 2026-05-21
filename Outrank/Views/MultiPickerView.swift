//
//  MultiPickerView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct MultiPickerView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    private var favorites: FetchedResults<Favorite>

    private let allTeams = AllTeams.teams

    private var favoriteTeamNames: Set<String> {
        Set(favorites.map(\.team))
    }

    private var uniqueFavorites: [Favorite] {
        var seen = Set<String>()
        return favorites.filter { seen.insert($0.team).inserted }
    }

    var body: some View {
        List {
            Section("Favorite Teams") {
                ForEach(uniqueFavorites) { favorite in
                    Button {
                        toggleSelection(team: favorite.team)
                    } label: {
                        FavoriteTeamRow(team: favorite.team, isFavorite: true)
                    }
                    .buttonStyle(.plain)
                }

                if favorites.isEmpty {
                    Text("No favorites yet ☹️")
                        .foregroundStyle(.secondary)
                }
            }

            Section("All Teams") {
                ForEach(allTeams, id: \.self) { team in
                    Button {
                        toggleSelection(team: team)
                    } label: {
                        FavoriteTeamRow(team: team, isFavorite: favoriteTeamNames.contains(team))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleSelection(team: String) {
        let matching = favorites.filter { $0.team == team }
        if matching.isEmpty {
            let favorite = Favorite(context: moc)
            favorite.team = team
            favorite.createdAt = .now
        } else {
            // Delete any/all matching rows. This both un-favorites the team and
            // self-heals any duplicate rows that may have accumulated.
            matching.forEach(moc.delete)
        }

        do {
            try moc.saveIfNeeded()
        } catch {
            print("[MultiPickerView] Failed to save favorites: \(error)")
        }
    }
}
