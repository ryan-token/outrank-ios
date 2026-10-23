//
//  RankingDetailView.swift
//  Outrank
//
//  Created by Ryan Token on 10/4/21.
//

import SwiftUI

/// Every team's ranking in one stat, with the selected team highlighted.
struct RankingDetailView: View {
    let team: String
    let stat: String
    let ranking: Int

    @State private var model = StatRankingsModel()
    @State private var reloadAttempt = 0

    private var humanReadableStat: String {
        Conversions.humanReadableStat(for: stat)
    }

    var body: some View {
        List {
            Section {
                LabeledContent {
                    Text(Conversions.humanReadableRanking(for: ranking))
                        .foregroundStyle(RankingStyle.color(for: ranking))
                } label: {
                    Text("\(team)'s Ranking")
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

                ForEach(model.entries) { entry in
                    TeamRankingRow(title: entry.title, ranking: entry.ranking, isCurrentTeam: entry.title == team)
                }

                if model.loadFailed {
                    RankingsLoadFailedRow(stat: humanReadableStat, reloadAttempt: $reloadAttempt)
                }
            }
        }
        .animation(.default, value: model.revision)
        .navigationTitle(humanReadableStat)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await model.load(stat: stat)
        }
        // Keyed on the retry counter, so tapping "Try Again" restarts a task SwiftUI still
        // owns and cancels, rather than an unstructured one. The stat itself never changes
        // for this view: the detail column gives each stat its own identity with `.id`.
        .task(id: reloadAttempt) {
            await model.load(stat: stat)
        }
    }
}

#Preview {
    NavigationStack {
        RankingDetailView(team: "Tulsa", stat: "FewestPenaltyYardsPerGame", ranking: 19)
    }
}
