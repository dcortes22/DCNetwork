//
//  ContentType.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

/// Represents the content type used in HTTP requests, specifying how data should be serialized and sent.
public enum ContentType {
    case json
    case formURLEncoded
    case formData(boundary: String)
    
    var value: String {
        switch self {
        case .json:
            return "application/json"
        case .formURLEncoded:
            return "application/x-www-form-urlencoded"
        case .formData(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}
