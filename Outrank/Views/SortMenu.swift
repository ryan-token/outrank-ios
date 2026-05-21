//
//  SortMenu.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import SwiftUI

struct SortMenu: View {
    @Binding var sortMethod: SortMethod

    var body: some View {
        Menu {
            Picker("Sort Rankings", selection: $sortMethod) {
                ForEach(SortMethod.allCases) { method in
                    Text(method.menuLabel).tag(method)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .accessibilityLabel("Sort Rankings")
        .onChange(of: sortMethod) {
            HapticGenerator.playSuccessHaptic()
        }
    }
}
