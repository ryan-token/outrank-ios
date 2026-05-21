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
    @Binding var teamRankings: [String: Int]

    let type: TeamPickerTypes
    private let allTeams = AllTeams.teams

    private var uniqueFavorites: [Favorite] {
        var seen = Set<String>()
        return favorites.filter { seen.insert($0.wrappedTeam).inserted }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Favorite Teams") {
                    ForEach(uniqueFavorites) { favorite in
                        Button {
                            chooseTeam(favorite.wrappedTeam)
                            dismiss()
                        } label: {
                            TeamPickerRow(team: favorite.wrappedTeam, isFavorite: true)
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
        }
    }

    private func chooseTeam(_ team: String) {
        Task {
            do {
                let fetched = try await TeamFetcher.getTeamRankingsFor(team: team)
                teamRankings = try fetched.allProperties()

                UserDefaults.standard.set(team, forKey: type.userDefaultsKey)
                self.team = team
                HapticGenerator.playSuccessHaptic()
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }

    private func removeFavorites(at offsets: IndexSet) {
        // Map row offsets to team names, then delete ALL favorites with that
        // team name. This cleans up any duplicate rows in a single swipe.
        let teamsToRemove = offsets.map { uniqueFavorites[$0].wrappedTeam }
        for team in teamsToRemove {
            for favorite in favorites where favorite.wrappedTeam == team {
                moc.delete(favorite)
            }
        }
        try? moc.save()
    }
}
