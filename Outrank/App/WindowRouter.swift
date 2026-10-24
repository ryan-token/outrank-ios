//
//  WindowRouter.swift
//  Outrank
//

import Foundation

/// Carries requests to switch a window to one of its Settings pages from screens deep
/// inside it, such as a team picker sheet. The window keeps its selection in scene
/// storage so it survives the scene being restored, so it applies each request itself.
@Observable
final class WindowRouter {
    private(set) var requestedSettingsDetail: SettingsDetail?

    func openSettings(_ detail: SettingsDetail) {
        requestedSettingsDetail = detail
    }

    /// Called once the window has applied the request, so asking for the same page
    /// again counts as a new request.
    func clearRequest() {
        requestedSettingsDetail = nil
    }
}
