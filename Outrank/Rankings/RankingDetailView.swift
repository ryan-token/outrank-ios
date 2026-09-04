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
    @State private var reloadAttempt = 0

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
                        .foregroundStyle(RankingStyle.color(for: ranking))
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
                    let teamName = AllTeams.name(forAPIKey: item.key)

                    OtherTeamRankingRow(
                        team: teamName,
                        ranking: item.value,
                        isCurrentTeam: team == teamName
                    )
                }

                if apiError {
                    RankingsLoadFailed(stat: humanReadableStat) {
                        reloadAttempt += 1
                    }
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
        .refreshable {
            await loadRankings()
        }
        // Keyed on the retry counter as well as the stat, so tapping "Try Again" restarts
        // a task SwiftUI still owns and cancels, rather than an unstructured one.
        .task(id: ReloadKey(stat: stat, attempt: reloadAttempt)) {
            await loadRankings()
        }
    }

    private struct ReloadKey: Hashable {
        let stat: String
        let attempt: Int
    }

    private func loadRankings() async {
        do {
            let fetched = try await StatFetcher.getStatRankingsFor(stat: stat)
            guard !Task.isCancelled else { return }
            statRankings = fetched.rankings
            apiError = false
        } catch is CancellationError {
            // The stat changed before this fetch completed; a newer task will populate rankings.
        } catch {
            guard !Task.isCancelled else { return }
            print("Request failed with error: \(error)")
            apiError = true
        }
    }
}

private struct RankingsLoadFailed: View {
    let stat: String
    let retry: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("😕 Error loading rankings for \(stat).")
                .foregroundStyle(.secondary)

            Button("Try Again", action: retry)
                .buttonStyle(.bordered)
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
                .foregroundStyle(RankingStyle.color(for: ranking))
        }
        .font(isCurrentTeam ? .headline : .body)
    }
}

#Preview {
    NavigationStack {
        RankingDetailView(team: "Tulsa", stat: "FewestPenaltyYardsPerGame", ranking: 19)
    }
}
