//
//  InfoExplanation.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

/// The ranking-color key for one page.
struct InfoExplanation: View {
    let source: InfoSource

    var body: some View {
        let green = Text("green ranking").foregroundStyle(.green).font(.headline)
        let red = Text("red ranking").foregroundStyle(.red).font(.headline)
        let grey = Text("grey ranking").foregroundStyle(.secondary).font(.headline)

        VStack(alignment: .leading) {
            Text(source.heading)
                .font(.headline)

            Group {
                Text("On this page, a \(green) \(source.greenDescription) A \(red) \(source.redDescription)")
                Text("A \(grey) \(source.greyDescription)")
                Text(source.otherPageNote)
            }
            .foregroundStyle(.secondary)
            .padding(.top)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}
