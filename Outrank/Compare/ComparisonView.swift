//
//  ComparisonView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct ComparisonView: View {
    @Environment(\.scenePhase) private var scenePhase

    @State private var model = ComparisonModel()
    @State private var presentedPicker: ComparisonSlot?
    @State private var isShowingInfoSheet = false

    var body: some View {
        NavigationStack {
            List {
                Section("Sorted by \(model.sortMethod.sectionLabel(rankingPrefix: model.teamOne))") {
                    ForEach(model.rows) { entry in
                        ComparisonRow(
                            title: entry.title,
                            teamOne: model.teamOne,
                            teamOneRanking: entry.teamOneRanking,
                            teamTwo: model.teamTwo,
                            teamTwoRanking: entry.teamTwoRanking
                        )
                    }
                }

                if model.loadFailed {
                    Text("😕 Error loading rankings. Please try again or try changing one of the teams.")
                        .foregroundStyle(.secondary)
                }
            }
            .animation(.default, value: model.revision)
            .refreshable {
                await model.loadBothTeams()
            }
            // The list owns the screen; the team controls ride above it in a bar that
            // reserves its own space and gives the rows a scroll-edge effect beneath it.
            .safeAreaBar(edge: .top) {
                ComparisonHeader(model: model, presentedPicker: $presentedPicker)
            }
            .navigationTitle("Compare Teams")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Info", systemImage: "info.circle", action: showInfoSheet)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    SortMenu(sortMethod: $model.sortMethod)
                }
            }
            .sheet(item: $presentedPicker) { slot in
                TeamPickerView(team: $model[team: slot])
            }
            .sheet(isPresented: $isShowingInfoSheet) {
                InfoView(source: .compare)
                    .presentationDetents([.medium, .large])
            }
            .task(id: ComparisonLoadKey(
                teamOne: model.teamOne,
                teamTwo: model.teamTwo,
                isActive: scenePhase == .active
            )) {
                guard scenePhase == .active else { return }
                await model.loadStaleTeams()
            }
        }
    }

    private func showInfoSheet() {
        isShowingInfoSheet = true
    }
}

#Preview {
    ComparisonView()
        .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
}
