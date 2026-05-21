//
//  RankingsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct RankingsView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("AppUsedCount") private var appUsedCount = 0

    @State private var currentTeam = UserDefaults.standard.string(forKey: "CurrentTeam") ?? "Air Force"
    @State private var teamRankings: [String: Int] = [:]
    @State private var sortMethod: SortMethod = .byStatAlphabetically
    @State private var apiError = false

    @State private var isShowingTeamPicker = false
    @State private var isShowingInfoSheet = false

    private var sortedRankings: [(key: String, value: Int)] {
        sortMethod.sort(teamRankings)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Sorted by \(sortMethod.sectionLabel())") {
                    ForEach(sortedRankings, id: \.key) { item in
                        NavigationLink(value: item.key) {
                            RankingRow(stat: item.key, ranking: item.value)
                        }
                    }

                    if apiError {
                        Text("😕 Error loading rankings for \(currentTeam). Please try again or try a different team.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .refreshable {
                await refreshRankings()
            }
            .animation(.default, value: teamRankings)
            .animation(.default, value: sortMethod)
            .navigationTitle(currentTeam)
            .navigationDestination(for: String.self) { stat in
                RankingDetailView(
                    team: currentTeam,
                    stat: stat,
                    ranking: teamRankings[stat] ?? 99999
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Choose Team") {
                        isShowingTeamPicker = true
                    }
                    .foregroundStyle(.primary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Info", systemImage: "info.circle") {
                        isShowingInfoSheet = true
                    }
                    .foregroundStyle(.primary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    SortMenu(sortMethod: $sortMethod)
                        .foregroundStyle(.primary)
                }
            }
            .sheet(isPresented: $isShowingTeamPicker) {
                TeamPickerView(
                    team: $currentTeam,
                    teamRankings: $teamRankings,
                    type: .rankings
                )
            }
            .sheet(isPresented: $isShowingInfoSheet) {
                InfoView(source: .rankings)
                    .presentationDetents([.medium])
            }
        }
        .tint(.primary)
        .task {
            if teamRankings.isEmpty {
                await refreshRankings()
            }
        }
        .onAppear {
            appUsedCount += 1
        }
    }

    private func refreshRankings() async {
        do {
            let fetchedRankings = try await TeamFetcher.getTeamRankingsFor(team: currentTeam)
            teamRankings = try fetchedRankings.allProperties()
            apiError = false
            if appUsedCount > 5 {
                requestReview()
            }
        } catch {
            print("Request failed with error: \(error)")
            apiError = true
        }
    }
}

private struct RankingRow: View {
    let stat: String
    let ranking: Int

    var body: some View {
        HStack(spacing: 8) {
            Text(Conversions.getHumanReadableStat(for: stat))
                .font(.headline)

            Spacer()

            Text(Conversions.getHumanReadableRanking(for: ranking))
                .foregroundStyle(ranking < 65 ? .green : .red)
        }
    }
}

#Preview {
    RankingsView()
        .environment(TabController())
}
