//
//  SettingsView.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI
import WidgetKit

enum SettingsDetail: Hashable {
    case favorites
    case tipJar
    case subscriptions
}

struct SettingsView: View {
    @State private var selectedDetail: SettingsDetail?

    var body: some View {
        NavigationSplitView {
            SettingsSidebar(selectedDetail: $selectedDetail)
        } detail: {
            SettingsDetailColumn(selectedDetail: selectedDetail)
        }
    }
}

private struct SettingsSidebar: View {
    @Binding var selectedDetail: SettingsDetail?

    var body: some View {
        List(selection: $selectedDetail) {
            PreferencesSection()
            SupportSection()
            GeneralSection()
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct SettingsDetailColumn: View {
    let selectedDetail: SettingsDetail?

    var body: some View {
        switch selectedDetail {
        case .favorites: MultiPickerView()
        case .tipJar: TipJarView()
        case .subscriptions: SubscriptionsView()
        case .none: WelcomeView(type: .settings)
        }
    }
}

private struct PreferencesSection: View {
    @State private var widgetTeam = UserDefaults(suiteName: AppGroup.groupId.rawValue)?
        .string(forKey: "WidgetTeam") ?? "Air Force"

    private let allTeams = AllTeams.teams

    var body: some View {
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
}

private struct SupportSection: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
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

            NavigationLink(value: SettingsDetail.tipJar) {
                SettingsRow(icon: "centsign.square.fill", iconColor: .orange, title: "Leave a Tip")
            }
            .accessibilityLabel("Leave a Tip")

            NavigationLink(value: SettingsDetail.subscriptions) {
                SettingsRow(icon: "dollarsign.square.fill", iconColor: .green, title: "Subscribe")
            }
        }
    }

    private func openWriteReview() {
        guard let url = URL(string: "https://apps.apple.com/us/app/outrank/id1588983785?action=write-review") else { return }
        openURL(url)
    }
}

private struct GeneralSection: View {
    @Environment(\.openURL) private var openURL
    @State private var isShowingAbout = false
    @State private var isShowingPrivacyDialog = false

    var body: some View {
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
            .sheet(isPresented: $isShowingAbout) {
                AboutView()
            }

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
