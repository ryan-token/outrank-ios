//
//  AppLinks.swift
//  Outrank
//
//  Created by Ryan Token on 10/5/21.
//

import Foundation

/// Every external URL the app opens, in one place.
nonisolated enum AppLinks {
    static let writeReview = url("https://apps.apple.com/us/app/outrank/id1588983785?action=write-review")
    static let privacyPolicy = url("https://ryantoken.com/privacy-policy")
    static let termsOfUse = url("https://ryantoken.com/terms-of-use")
    static let catchUp = url("itms-apps://apps.apple.com/us/app/catchup-keep-in-touch/id1358023550")
    static let hotLocalFood = url("itms-apps://apps.apple.com/us/app/hot-local-food/id1621818779")

    /// A new email to the developer with the subject already filled in.
    static let featureRequest: URL = {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = "outrankapp@gmail.com"
        components.queryItems = [URLQueryItem(name: "subject", value: "Outrank Feature Request")]
        guard let url = components.url else {
            preconditionFailure("Could not build the feature request email URL.")
        }
        return url
    }()

    /// These are fixed literals, so a failure here is a typo caught the first time the
    /// app runs, not a condition to recover from at runtime.
    private static func url(_ string: String) -> URL {
        guard let url = URL(string: string) else {
            preconditionFailure("Malformed URL literal: \(string)")
        }
        return url
    }
}
