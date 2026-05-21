//
//  SettingsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @Environment(\.openURL) private var openURL

    @State private var widgetTeam = UserDefaults(suiteName: AppGroup.groupId.rawValue)?
        .string(forKey: "WidgetTeam") ?? "Air Force"
    @State private var isShowingAbout = false
    @State private var isShowingPrivacyDialog = false

    private let allTeams = AllTeams.teams

    var body: some View {
        NavigationStack {
            Form {
                preferencesSection
                supportSection
                generalSection
            }
            .sheet(isPresented: $isShowingAbout) {
                AboutView()
            }
            .navigationTitle("Settings")
        }
    }

    private var preferencesSection: some View {
        Section("Preferences") {
            MultiPicker()

            Picker(selection: $widgetTeam) {
                ForEach(allTeams, id: \.self) { team in
                    Text(team).tag(team)
                }
            } label: {
                Label {
                    Text("Widget")
                } icon: {
                    Image(systemName: "square.text.square.fill")
                        .font(.title)
                        .foregroundStyle(.purple)
                }
            }
            .onChange(of: widgetTeam) {
                UserDefaults(suiteName: AppGroup.groupId.rawValue)?
                    .set(widgetTeam, forKey: "WidgetTeam")
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }

    private var supportSection: some View {
        Section("Support") {
            Button(action: openWriteReview) {
                SettingsRow(
                    icon: "heart.square.fill",
                    iconColor: .red,
                    title: "Rate",
                    showsExternalIndicator: true
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                TipJarView()
            } label: {
                SettingsRow(icon: "centsign.square.fill", iconColor: .orange, title: "Leave a Tip")
            }
            .accessibilityLabel("Leave a Tip")

            NavigationLink {
                SubscriptionsView()
            } label: {
                SettingsRow(icon: "dollarsign.square.fill", iconColor: .green, title: "Subscribe")
            }
        }
    }

    private var generalSection: some View {
        Section("General") {
            Button(action: sendFeatureRequestEmail) {
                SettingsRow(
                    icon: "bolt.square.fill",
                    iconColor: .mint,
                    title: "Feature Request",
                    showsExternalIndicator: true
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Send an email with a feature request")

            Button {
                isShowingAbout = true
            } label: {
                SettingsRow(icon: "person.crop.square.fill", iconColor: .blue, title: "About")
            }
            .buttonStyle(.plain)
            .accessibilityLabel("About")

            Button {
                isShowingPrivacyDialog = true
            } label: {
                SettingsRow(icon: "lock.square.fill", iconColor: .gray, title: "Terms & Privacy Policy")
            }
            .buttonStyle(.plain)
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

    private func openWriteReview() {
        guard let url = URL(string: "https://apps.apple.com/us/app/outrank/id1588983785?action=write-review") else { return }
        openURL(url)
    }

    private func sendFeatureRequestEmail() {
        let mailto = "mailto:outrankapp@gmail.com?subject=Outrank Feature Request"
        guard let encoded = mailto.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encoded) else { return }
        openURL(url)
    }

    private func openPrivacyPolicy() {
        guard let url = URL(string: "https://ryantoken.com/privacy-policy") else { return }
        openURL(url)
    }

    private func openTermsOfUse() {
        guard let url = URL(string: "https://ryantoken.com/terms-of-use") else { return }
        openURL(url)
    }
}

#Preview {
    SettingsView()
        .environment(TabController())
        .environment(Store())
}
