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

    @State private var router = WindowRouter()

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
        .environment(router)
        // The selection lives in scene storage, which the router can't write, so the
        // window applies each request here.
        .onChange(of: router.requestedSettingsDetail) { _, detail in
            guard let detail else { return }
            activeTab = .settings
            settingsDetail = detail
            router.clearRequest()
        }
        #if DEBUG
        .onAppear {
            if let tab = ScreenshotMode.tab {
                activeTab = tab
            }
        }
        #endif
    }
}

#Preview {
    MainView()
        .environment(Store())
        .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
}
