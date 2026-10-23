//
//  GeneralSection.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct GeneralSection: View {
    @Binding var isShowingAbout: Bool

    @Environment(\.openURL) private var openURL
    @State private var isShowingPrivacyDialog = false

    var body: some View {
        Section("General") {
            Link(destination: AppLinks.featureRequest) {
                SettingsRow(
                    icon: "bolt.square.fill",
                    iconColor: .mint,
                    title: "Feature Request",
                    showsExternalIndicator: true
                )
            }
            .accessibilityLabel("Send an email with a feature request")

            Button(action: showAbout) {
                SettingsRow(icon: "person.crop.square.fill", iconColor: .blue, title: "About")
            }

            Button(action: showPrivacyDialog) {
                SettingsRow(icon: "lock.square.fill", iconColor: .gray, title: "Terms & Privacy Policy")
            }
            .accessibilityLabel("Terms of Use and Privacy Policy")
            .confirmationDialog(
                "Terms of Use and Privacy Policy",
                isPresented: $isShowingPrivacyDialog,
                titleVisibility: .visible
            ) {
                Button("Terms of Use", action: openTermsOfUse)
                Button("Privacy Policy", action: openPrivacyPolicy)
            }
        }
    }

    private func showAbout() {
        isShowingAbout = true
    }

    private func showPrivacyDialog() {
        isShowingPrivacyDialog = true
    }

    private func openTermsOfUse() {
        openURL(AppLinks.termsOfUse)
    }

    private func openPrivacyPolicy() {
        openURL(AppLinks.privacyPolicy)
    }
}
