//
//  InfoView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

enum InfoSource {
    case rankings
    case compare

    var greenDescription: LocalizedStringResource {
        switch self {
        case .rankings: "means the team ranks in the *top half* of the country."
        case .compare: "means the team ranks *better* on a given stat than the team you're comparing them with."
        }
    }

    var redDescription: LocalizedStringResource {
        switch self {
        case .rankings: "means the team ranks in the *bottom half*."
        case .compare: "means the team ranks *worse* than the other team."
        }
    }

    /// Both pages use the same neutral tint for a team with no ranking in a stat.
    var greyDescription: LocalizedStringResource {
        "means the team isn't ranked in that stat yet."
    }

    var heading: LocalizedStringResource {
        switch self {
        case .rankings: "Rankings page colors"
        case .compare: "Compare page colors"
        }
    }

    var otherPageNote: LocalizedStringResource {
        switch self {
        case .rankings: "The colors work differently on the **Compare** page."
        case .compare: "The colors work differently on the **Rankings** page."
        }
    }
}

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss

    let source: InfoSource

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(source.heading)
                    .font(.headline)
                    .padding(.horizontal)

                let green = Text("green ranking ").foregroundStyle(.green).font(.headline)
                let red = Text("red ranking ").foregroundStyle(.red).font(.headline)
                let grey = Text("grey ranking ").foregroundStyle(.secondary).font(.headline)

                Text("On this page, a \(green) \(source.greenDescription) A \(red) \(source.redDescription)")
                    .foregroundStyle(.secondary)
                    .padding(15)

                Text("A \(grey) \(source.greyDescription)")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 15)

                Text(source.otherPageNote)
                    .foregroundStyle(.secondary)
                    .padding(15)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: dismiss.callAsFunction).bold()
                }
            }
        }
    }
}

#Preview {
    InfoView(source: .rankings)
}
