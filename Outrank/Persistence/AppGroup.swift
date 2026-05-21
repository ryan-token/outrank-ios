//
//  AppGroup.swift
//  Outrank
//
//  Created by Ryan Token on 10/14/21.
//

import Foundation

nonisolated enum AppGroup: String {
    case groupId = "group.com.ryantoken.teamrankings"

    var containerURL: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: rawValue)!
    }
}
