//
//  RankingsLoadFailedRow.swift
//  Outrank
//
//  Created by Ryan Token on 10/4/21.
//

import SwiftUI

struct RankingsLoadFailedRow: View {
    let stat: String

    /// Incremented to retry. A binding rather than a closure, so SwiftUI can tell when
    /// this row's inputs are unchanged and skip re-evaluating it.
    @Binding var reloadAttempt: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text("😕 Error loading rankings for \(stat).")
                .foregroundStyle(.secondary)

            Button("Try Again", action: retry)
                .buttonStyle(.bordered)
        }
    }

    private func retry() {
        reloadAttempt += 1
    }
}
