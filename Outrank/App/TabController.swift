//
//  TabController.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

/// The selected tab for one window. Owned per scene, so two windows side by side on
/// iPad or iPhone Duo's inner display can each show a different tab.
@Observable
final class TabController {
    var activeTab: AppTab = .rankings

    func open(_ tab: AppTab) {
        activeTab = tab
    }
}
