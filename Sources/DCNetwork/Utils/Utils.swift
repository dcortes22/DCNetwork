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
        case let boolValue as Bool:
            return String(boolValue)
        case let dict as [String: Any]:
            return jsonString(from: dict)
        case let array as [Any]:
            return jsonString(from: array)
        default:
            return nil
        }
    }
    
    private static func jsonString(from object: Any) -> String? {
        guard JSONSerialization.isValidJSONObject(object),
              let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
