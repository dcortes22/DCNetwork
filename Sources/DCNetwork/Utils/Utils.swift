//
//  Utils.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

struct Utils {
    static func convertToString(_ value: Any) -> String? {
        switch value {
        case let intValue as Int:
            return String(intValue)
        case let floatValue as Float:
            return String(floatValue)
        case let doubleValue as Double:
            return String(doubleValue)
        case let stringValue as String:
            return stringValue
        default:
            return nil
        }
    }
}
