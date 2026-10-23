//
//  SettingsSidebar.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct SettingsSidebar: View {
    @Binding var selectedDetail: SettingsDetail?

    @State private var isShowingAbout = false

    var body: some View {
        List(selection: $selectedDetail) {
            PreferencesSection()
            SupportSection()
            GeneralSection(isShowingAbout: $isShowingAbout)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        // Presented from the list rather than its row, so the sheet doesn't depend on a
        // lazily created row staying alive.
        .sheet(isPresented: $isShowingAbout) {
            AboutView()
        }
    }
}
