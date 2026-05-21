//
//  MainView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct MainView: View {
    @Environment(TabController.self) private var tabController

    var body: some View {
        @Bindable var tabController = tabController

        TabView(selection: $tabController.activeTab) {
            Tab("Rankings", systemImage: "list.bullet.rectangle.portrait", value: AppTab.rankings) {
                RankingsView()
            }

            Tab("Compare", systemImage: "eyeglasses", value: AppTab.compare) {
                ComparisonView()
            }

            Tab("Settings", systemImage: "gear", value: AppTab.settings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainView()
        .environment(TabController())
        .environment(Store())
}
