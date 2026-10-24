//
//  TestSupport.swift
//  OutrankTests
//

import Foundation
@testable import Outrank

/// A failure for stubbed fetches to throw.
struct StubError: Error {}

/// Defaults in their own suite, so tests neither read nor clobber the app's settings.
func makeIsolatedDefaults() -> UserDefaults {
    let suiteName = "OutrankTests.\(UUID().uuidString)"
    guard let defaults = UserDefaults(suiteName: suiteName) else {
        preconditionFailure("Could not create a UserDefaults suite for testing.")
    }
    return defaults
}

/// Lets a stubbed fetch reach the model it was injected into, to simulate the user
/// changing something while a request is in flight.
final class ModelReference<Model: AnyObject> {
    weak var model: Model?
}
