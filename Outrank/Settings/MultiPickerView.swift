//
//  MultiPickerView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import CoreData
import OSLog
import SwiftUI

/// Lets the user star and unstar teams; starred teams appear first in the team picker.
struct MultiPickerView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    private var favorites: FetchedResults<Favorite>

    @State private var isShowingSaveError = false

    private static let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "MultiPickerView")

    var body: some View {
        // Built once per update, not once per row in the 130-plus row team list below.
        let favoriteTeamNames = Set(favorites.map(\.team))

        List {
            Section("Favorite Teams") {
                ForEach(favorites.uniquedByTeam()) { favorite in
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
                ForEach(AllTeams.all) { team in
                    Button {
                        toggleSelection(team: team.name)
                    } label: {
                        FavoriteTeamRow(team: team.name, isFavorite: favoriteTeamNames.contains(team.name))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Couldn't Update Favorites", isPresented: $isShowingSaveError) {
        } message: {
            Text("Please try again.")
        }
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
            moc.rollback()
            Self.logger.error("Failed to save favorites: \(error.localizedDescription)")
            isShowingSaveError = true
        }
    }
}

#Preview {
    NavigationStack {
        MultiPickerView()
            .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
    }
}
