//
//  RankingsSidebar.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

/// The selected team's ranking in every stat. Selecting a stat shows every team's
/// ranking in it: beside this list in regular widths, pushed in compact ones.
struct RankingsSidebar: View {
    @Bindable var model: TeamRankingsModel
    @Binding var selectedStat: String?
    @Binding var isShowingTeamPicker: Bool
    @Binding var isShowingInfoSheet: Bool

    var body: some View {
        List(selection: $selectedStat) {
            Section("Sorted by \(model.sortMethod.sectionLabel())") {
                ForEach(model.sortedRankings) { entry in
                    NavigationLink(value: entry.id) {
                        RankingRow(title: entry.title, ranking: entry.ranking, titleFont: .headline)
                    }
                }

                if model.loadFailed {
                    Text("😕 Error loading rankings for \(model.team). Please try again or try a different team.")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .refreshable {
            await model.load()
        }
        .animation(.default, value: model.revision)
        .navigationTitle(model.team)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            // Each item has a symbol as well as a title, so on iPhone Duo it can move
            // into the vertical bar instead of holding a horizontal bar open.
            ToolbarItem(placement: .topBarLeading) {
                Button("Choose Team", systemImage: "person.3", action: showTeamPicker)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Info", systemImage: "info.circle", action: showInfoSheet)
            }

            ToolbarItem(placement: .topBarTrailing) {
                SortMenu(sortMethod: $model.sortMethod)
            }
        }
    }

    private func showTeamPicker() {
        isShowingTeamPicker = true
    }

    private func showInfoSheet() {
        isShowingInfoSheet = true
    }
}
