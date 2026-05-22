//
//  RankingDetailView.swift
//  Outrank
//
//  Created by Ryan Token on 10/4/21.
//

import SwiftUI

struct RankingDetailView: View {
    @State private var statRankings: [String: Int] = [:]
    @State private var apiError = false

    let team: String
    let stat: String
    let ranking: Int

    private var sortedRankings: [(key: String, value: Int)] {
        statRankings.sorted { $0.value < $1.value }
    }

    private var humanReadableStat: String {
        Conversions.getHumanReadableStat(for: stat)
    }

    private var humanReadableRanking: String {
        Conversions.getHumanReadableRanking(for: ranking)
    }

    var body: some View {
        List {
            Section {
                HStack {
                    Text("\(team)'s Ranking:")
                    Text(humanReadableRanking)
                        .foregroundStyle(ranking < 65 ? .green : .red)
                }
                .font(.headline)
            }

            Section {
                Text("Description:")
                    .font(.headline)

                Text(StatDescriptions.description(for: stat))
                    .foregroundStyle(.secondary)
            }

            Section {
                Text("All Rankings For This Stat:")
                    .font(.headline)

                ForEach(sortedRankings, id: \.key) { item in
                    OtherTeamRankingRow(
                        team: Conversions.getHumanReadableTeam(from: item.key),
                        ranking: item.value,
                        isCurrentTeam: team == Conversions.getHumanReadableTeam(from: item.key)
                    )
                }

                if apiError {
                    Text("😕 Error loading rankings for \(humanReadableStat).")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .animation(.default, value: statRankings)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(humanReadableStat).font(.headline)
            }
        }
        .task {
            if statRankings.isEmpty {
                await loadRankings()
            }
        }
    }

    private func loadRankings() async {
        do {
            let fetched = try await StatFetcher.getStatRankingsFor(stat: stat)
            statRankings = try fetched.allProperties()
            apiError = false
        } catch {
            print("Request failed with error: \(error)")
            apiError = true
        }
    }
}

private struct OtherTeamRankingRow: View {
    let team: String
    let ranking: Int
    let isCurrentTeam: Bool

    var body: some View {
        HStack(spacing: 8) {
            Text(team)
            Spacer()
            Text(Conversions.getHumanReadableRanking(for: ranking))
                .foregroundStyle(ranking < 65 ? .green : .red)
        }
        .font(isCurrentTeam ? .headline : .body)
    }
}

#Preview {
    NavigationStack {
        RankingDetailView(team: "Tulsa", stat: "FewestPenaltyYardsPerGame", ranking: 19)
    }
}
