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
    @Environment(TabController.self) private var tabController

    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    private var favorites: FetchedResults<Favorite>

    @Binding var team: String

    @State private var chooseHapticTrigger = 0
    @State private var isShowingRemoveError = false

    private static let logger = Logger(subsystem: "com.ryantoken.Outrank", category: "TeamPickerView")

    var body: some View {
        NavigationStack {
            List {
                Section("Favorite Teams") {
                    ForEach(favorites.uniquedByTeam()) { favorite in
                        Button {
                            choose(favorite.team)
                        } label: {
                            TeamPickerRow(team: favorite.team, isFavorite: true)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: removeFavorites)

                    if favorites.isEmpty {
                        Button("Choose favorites in Settings", systemImage: "gear", action: openFavoritesSettings)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("All Teams") {
                    ForEach(AllTeams.all) { fbsTeam in
                        Button {
                            choose(fbsTeam.name)
                        } label: {
                            TeamPickerRow(team: fbsTeam.name, isFavorite: false)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
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
        tabController.open(.settings)
    }

    private func removeFavorites(at offsets: IndexSet) {
        // Map row offsets to team names, then delete ALL favorites with that
        // team name. This cleans up any duplicate rows in a single swipe.
        let uniqueFavorites = favorites.uniquedByTeam()
        let teamsToRemove = Set(offsets.map { uniqueFavorites[$0].team })
        for favorite in favorites where teamsToRemove.contains(favorite.team) {
            moc.delete(favorite)
        }

        do {
            try moc.saveIfNeeded()
        } catch {
            moc.rollback()
            Self.logger.error("Failed to remove favorites: \(error.localizedDescription)")
            isShowingRemoveError = true
        }
    }
}

#Preview {
    TeamPickerView(team: .constant("Tulsa"))
        .environment(TabController())
        .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
}
