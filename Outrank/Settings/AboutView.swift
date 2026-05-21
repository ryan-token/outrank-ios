//
//  AboutView.swift
//  Outrank
//
//  Created by Ryan Token on 10/6/21.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private let catchUpURL = URL(string: "itms-apps://apps.apple.com/us/app/catchup-keep-in-touch/id1358023550")!
    private let hotLocalFoodURL = URL(string: "itms-apps://apps.apple.com/us/app/hot-local-food/id1621818779")!

    var body: some View {
        NavigationStack {
            VStack(spacing: 7) {
                Image("Outrank")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(.rect(cornerRadius: 20))

                Text("Outrank")
                    .font(.largeTitle)
                    .bold()

                Text("Made with ❤️ by an independent developer")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Made with love by an independent developer")

                Form {
                    Section {
                        Text("I built Outrank because I needed it. I wanted a quick way to find where my favorite teams stacked up, but couldn't find a service that provided it.")
                        Text("The app is free with no ads. It makes me no money by default. If you enjoy Outrank I'd love it if you left a tip or subscribed :)")
                    }

                    Section("Try my other apps") {
                        Button {
                            openURL(catchUpURL)
                        } label: {
                            OtherAppRow(
                                image: "CatchUp",
                                title: "CatchUp – Keep in Touch",
                                subtitle: "Stay in touch with those who matter most"
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Try out this developer's other app: CatchUp – Keep in Touch")

                        Button {
                            openURL(hotLocalFoodURL)
                        } label: {
                            OtherAppRow(
                                image: "HLF",
                                title: "Hot Local Food",
                                subtitle: "Find love, then eat it"
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Try out this developer's other app: Hot Local Food")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: dismiss.callAsFunction).bold()
                }
            }
        }
    }
}

private struct OtherAppRow: View {
    let image: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 15) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(.rect(cornerRadius: 11))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    AboutView()
}
