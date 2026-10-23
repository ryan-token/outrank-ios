//
//  AboutView.swift
//  Outrank
//
//  Created by Ryan Token on 10/6/21.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            // The form owns the whole sheet, header included, so everything scrolls
            // together on short windows and at large text sizes.
            Form {
                Section {
                    AboutHeader()
                }
                .listRowBackground(Color.clear)

                Section {
                    Text("""
                        I built Outrank because I needed it. I wanted a quick way to find where my \
                        favorite teams stacked up, but couldn't find a service that provided it.
                        """)
                    Text("""
                        The app is free with no ads. It makes me no money by default. If you enjoy \
                        Outrank I'd love it if you left a tip or subscribed :)
                        """)
                }

                Section("Try my other apps") {
                    Link(destination: AppLinks.catchUp) {
                        OtherAppRow(
                            image: .catchUp,
                            title: "CatchUp: Keep in Touch",
                            subtitle: "Personal relationship manager"
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Try out this developer's other app, CatchUp: Keep in Touch")

                    Link(destination: AppLinks.hotLocalFood) {
                        OtherAppRow(
                            image: .HLF,
                            title: "Hot Local Food: Find Dinner",
                            subtitle: "Swipe & discover restaurants"
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Try out this developer's other app, Hot Local Food: Find Dinner")
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close, action: dismiss.callAsFunction)
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
