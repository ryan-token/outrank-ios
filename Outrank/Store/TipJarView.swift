//
//  TipJarView.swift
//  Outrank
//
//  Created by Ryan Token on 10/6/21.
//

import SwiftUI

struct TipJarView: View {
    @Environment(Store.self) private var store

    var body: some View {
        List {
            Section("Tip Options") {
                ForEach(store.tips) { tip in
                    ListTipOptionsView(product: tip)
                }
            }

            Section {
                Text("Outrank is free with no ads. If you find it useful, please consider supporting development by leaving a tip.")
                    .foregroundStyle(.secondary)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Tip Jar")
    }
}

#Preview {
    NavigationStack {
        TipJarView()
            .environment(Store())
    }
}
