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
        // A task-specific symbol rather than an ellipsis, so if the toolbar runs out of
        // room this reads as "sort" inside the system overflow menu.
        Menu("Sort Rankings", systemImage: "arrow.up.arrow.down") {
            Picker("Sort Rankings", selection: $sortMethod) {
                ForEach(SortMethod.allCases) { method in
                    Text(method.menuLabel).tag(method)
                }
            }
        }
        .sensoryFeedback(.success, trigger: sortMethod)
    }
}
