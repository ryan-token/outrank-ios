//
//  SettingsDetailColumn.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

struct SettingsDetailColumn: View {
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
