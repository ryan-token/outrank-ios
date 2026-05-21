//
//  TabController.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import SwiftUI

enum AppTab: Hashable {
    case rankings
    case compare
    case settings
}

@Observable
final class TabController {
    var activeTab: AppTab = .rankings

    func open(_ tab: AppTab) {
        activeTab = tab
    }
}
