//
//  RankingsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import StoreKit
import SwiftUI

struct RankingsView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("AppUsedCount") private var appUsedCount = 0

    @State private var model = TeamRankingsModel()
    @State private var selectedStat: String?
    @State private var isShowingTeamPicker = false
    @State private var isShowingInfoSheet = false

    var body: some View {
        // One split view at every size. It collapses into a stack in compact widths and
        // expands into columns in regular ones, driven by `selectedStat` either way, so
        // folding iPhone Duo, rotating, or resizing an iPad window keeps the user's place.
        NavigationSplitView {
            RankingsSidebar(
                model: model,
                selectedStat: $selectedStat,
                isShowingTeamPicker: $isShowingTeamPicker,
                isShowingInfoSheet: $isShowingInfoSheet
            )
        } detail: {
            RankingsDetailColumn(model: model, selectedStat: selectedStat)
        }
        .tint(.primary)
        .sheet(isPresented: $isShowingTeamPicker) {
            TeamPickerView(team: $model.team)
        }
        .sheet(isPresented: $isShowingInfoSheet) {
            InfoView(source: .rankings)
                .presentationDetents([.medium, .large])
        }
        .task(id: model.team) {
            await refreshRankings()
        }
        .onAppear {
            appUsedCount += 1
        }
    }

    private func refreshRankings() async {
        if await model.load(), appUsedCount > 5 {
            requestReview()
        }
    }
}

#Preview {
    RankingsView()
        .environment(TabController())
        .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
}
