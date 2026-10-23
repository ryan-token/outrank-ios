//
//  MainView.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct MainView: View {
    // Scene-level state rather than app-level, so each window keeps its own tab.
    @State private var tabController = TabController()

    var body: some View {
        TabView(selection: $tabController.activeTab) {
            Tab("Rankings", systemImage: "list.bullet.rectangle.portrait", value: .rankings) {
                RankingsView()
            }

            Tab("Compare", systemImage: "eyeglasses", value: .compare) {
                ComparisonView()
            }

            Tab("Settings", systemImage: "gear", value: .settings) {
                SettingsView()
            }
        }
        .environment(tabController)
    }
}

#Preview {
    MainView()
        .environment(Store())
        .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
}
