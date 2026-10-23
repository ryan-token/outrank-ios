//
//  TeamPickerView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import CoreData
import OSLog
import SwiftUI

/// A sheet for choosing a team, with the user's favorites first. Writes the choice to
/// `team`; whoever owns that binding decides how to store it.
struct TeamPickerView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    @Environment(WindowRouter.self) private var router

    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    private var favorites: FetchedResults<Favorite>

    @Binding var team: String

    @State private var search = TeamSearch()
    @State private var chooseHapticTrigger = 0
    @State private var isShowingRemoveError = false

    private static let logger = Logger(category: "TeamPickerView")

    var body: some View {
        let matchingFavorites = favorites.uniquedByTeam().filter { search.matches($0.team) }

        NavigationStack {
            List {
                if !search.isSearching || !matchingFavorites.isEmpty {
                    Section("Favorite Teams") {
                        ForEach(matchingFavorites) { favorite in
                            Button {
                                choose(favorite.team)
                            } label: {
                                TeamPickerRow(team: favorite.team, isFavorite: true)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete { offsets in
                            removeFavorites(at: offsets, in: matchingFavorites)
                        }

                        if favorites.isEmpty {
                            Button("Choose favorites in Settings", systemImage: "gear", action: openFavoritesSettings)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if !search.matchingTeams.isEmpty {
                    Section("All Teams") {
                        ForEach(search.matchingTeams) { fbsTeam in
                            Button {
                                choose(fbsTeam.name)
                            } label: {
                                TeamPickerRow(team: fbsTeam.name, isFavorite: false)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .overlay {
                if search.matchingTeams.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .searchable(text: $search.text, prompt: "Search Teams")
            .navigationTitle("Choose Team")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close, action: dismiss.callAsFunction)
                }
            }
            .sensoryFeedback(.success, trigger: chooseHapticTrigger)
            .alert("Couldn't Remove Favorite", isPresented: $isShowingRemoveError) {
            } message: {
                Text("Please try again.")
            }
        }
    }

    private func choose(_ selectedTeam: String) {
        team = selectedTeam
        chooseHapticTrigger += 1
        dismiss()
    }

    private func openFavoritesSettings() {
        dismiss()
        router.openSettings(.favorites)
    }

    /// - Parameter shownFavorites: The favorites as listed, possibly narrowed by a search,
    ///   which `offsets` index into.
    private func removeFavorites(at offsets: IndexSet, in shownFavorites: [Favorite]) {
        // Map row offsets to team names, then delete ALL favorites with that
        // team name. This cleans up any duplicate rows in a single swipe.
        let teamsToRemove = Set(offsets.map { shownFavorites[$0].team })
        for favorite in favorites where teamsToRemove.contains(favorite.team) {
            moc.delete(favorite)
        }

        do {
            try moc.saveIfNeeded()
        } catch {
            moc.rollback()
            Self.logger.error("Failed to remove favorites: \(String(describing: error))")
            isShowingRemoveError = true
        }
    }
}

#Preview {
    TeamPickerView(team: .constant("Tulsa"))
        .environment(WindowRouter())
        .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
}
