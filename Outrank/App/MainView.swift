//
//  MainView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct MainView: View {
    // Scene storage, so each window keeps its own place and gets it back when the
    // system discards and restores the scene.
    @SceneStorage("ActiveTab") private var activeTab = AppTab.rankings
    @SceneStorage("SettingsDetail") private var settingsDetail: SettingsDetail?

    var body: some View {
        TabView(selection: $activeTab) {
            Tab("Rankings", systemImage: "list.bullet.rectangle.portrait", value: .rankings) {
                RankingsView()
            }

            Tab("Compare", systemImage: "eyeglasses", value: .compare) {
                ComparisonView()
            }

            Tab("Settings", systemImage: "gear", value: .settings) {
                SettingsView(selectedDetail: $settingsDetail)
            }
        }
        .environment(\.openSettings, OpenSettingsAction(handler: openSettings))
    }

    private func openSettings(_ detail: SettingsDetail) {
        activeTab = .settings
        settingsDetail = detail
    }
}

#Preview {
    MainView()
        .environment(Store())
        .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
}
