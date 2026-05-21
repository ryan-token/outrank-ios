//
//  LoopableStruct.swift
//  Outrank
//
//  Created by Ryan Token on 10/2/21.
//

import Foundation

nonisolated protocol Loopable {
    func allProperties() throws -> [String: Int]
}

enum LoopableError: Error {
    case unsupportedReflection
}

extension Loopable {
    nonisolated func allProperties() throws -> [String: Int] {
        let mirror = Mirror(reflecting: self)
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw LoopableError.unsupportedReflection
        }

        var result: [String: Int] = [:]
        for (property, value) in mirror.children {
            guard let property else { continue }
            result[property] = (value as? Int) ?? 99999
        }
        return result
    }
}
