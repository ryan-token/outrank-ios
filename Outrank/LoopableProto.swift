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

extension Loopable {
    nonisolated func allProperties() throws -> [String: Int] {
        var result: [String: Int] = [:]

        let mirror = Mirror(reflecting: self)

        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            
            if let intValue = value as? Int {
                result[property] = intValue
            } else {
                result[property] = 99999
            }
        }

        return result
    }
}
