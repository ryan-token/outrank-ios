//
//  SupportSection.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct SupportSection: View {
    var body: some View {
        Section("Support") {
            Link(destination: AppLinks.writeReview) {
                SettingsRow(
                    icon: "heart.square.fill",
                    iconColor: .red,
                    title: "Rate",
                    showsExternalIndicator: true
                )
            }

            NavigationLink(value: SettingsDetail.tipJar) {
                SettingsRow(icon: "centsign.square.fill", iconColor: .orange, title: "Leave a Tip")
            }

            NavigationLink(value: SettingsDetail.subscriptions) {
                SettingsRow(icon: "dollarsign.square.fill", iconColor: .green, title: "Subscribe")
            }
        }
    }
}
