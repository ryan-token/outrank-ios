//
//  TeamPickerView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct TeamPickerView: View {
    enum TeamPickerTypes: String, Identifiable {
        case rankings
        case comparisonTeamOne
        case comparisonTeamTwo

        var id: String { rawValue }

        var userDefaultsKey: String {
            switch self {
            case .rankings: "CurrentTeam"
            case .comparisonTeamOne: "TeamOne"
            case .comparisonTeamTwo: "TeamTwo"
            }
        }
    }

    @Environment(\.managedObjectContext) private var moc
    @Environment(\.dismiss) private var dismiss
    @Environment(TabController.self) private var tabController

    @FetchRequest(fetchRequest: Favorite.allFavoritesFetchRequest, animation: .default)
    private var favorites: FetchedResults<Favorite>

    @Binding var team: String

    let type: TeamPickerTypes
    private let allTeams = AllTeams.teams

    @State private var chooseHapticTrigger = 0

    private var uniqueFavorites: [Favorite] {
        var seen = Set<String>()
        return favorites.filter { seen.insert($0.team).inserted }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Favorite Teams") {
                    ForEach(uniqueFavorites) { favorite in
                        Button {
                            chooseTeam(favorite.team)
                            dismiss()
                        } label: {
                            TeamPickerRow(team: favorite.team, isFavorite: true)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: removeFavorites)

                    if favorites.isEmpty {
                        Button {
                            dismiss()
                            tabController.open(.settings)
                        } label: {
                            HStack(spacing: 6) {
                                Text("Choose favorites in")
                                Label("Settings", systemImage: "gear")
                                    .labelStyle(.titleAndIcon)
                                Spacer()
                            }
                            .foregroundStyle(.secondary)
                            .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Section("All Teams") {
                    ForEach(allTeams, id: \.self) { team in
                        Button {
                            chooseTeam(team)
                            dismiss()
                        } label: {
                            TeamPickerRow(team: team, isFavorite: false)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Choose Team")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: dismiss.callAsFunction).bold()
                }
            }
            .sensoryFeedback(.success, trigger: chooseHapticTrigger)
        }
    }

    private func chooseTeam(_ team: String) {
        UserDefaults.standard.set(team, forKey: type.userDefaultsKey)
        self.team = team
        chooseHapticTrigger += 1
    }

    private func removeFavorites(at offsets: IndexSet) {
        // Map row offsets to team names, then delete ALL favorites with that
        // team name. This cleans up any duplicate rows in a single swipe.
        let teamsToRemove = offsets.map { uniqueFavorites[$0].team }
        for team in teamsToRemove {
            for favorite in favorites where favorite.team == team {
                moc.delete(favorite)
            }
        }

        do {
            try moc.saveIfNeeded()
        } catch {
            print("[TeamPickerView] Failed to remove favorites: \(error)")
        }
    }
}
