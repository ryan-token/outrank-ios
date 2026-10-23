//
//  SettingsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedDetail: SettingsDetail?

    var body: some View {
        // One split view at every size: it collapses to a stack in compact widths and
        // keeps `selectedDetail` across folds, rotations, and window resizes.
        NavigationSplitView {
            SettingsSidebar(selectedDetail: $selectedDetail)
        } detail: {
            SettingsDetailColumn(selectedDetail: selectedDetail)
        }
    }
}

#Preview {
    SettingsView()
        .environment(TabController())
        .environment(Store())
        .environment(\.managedObjectContext, PersistentContainer.preview.viewContext)
}
