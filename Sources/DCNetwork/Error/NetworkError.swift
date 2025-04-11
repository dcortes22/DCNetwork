//
//  NetworkError.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case invalidParametersSerialization
    case statusCodeError(Int)
    case dataDecodingError(Error)
    case decodeError(String)
    case emptyResponse
    case unknownError
    case apiError(String, Int)
    
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.invalidParametersSerialization, .invalidParametersSerialization):
            return true
        case (.statusCodeError(let lhs), .statusCodeError(let rhs)):
            return lhs == rhs
        case (.dataDecodingError(let lhs), .dataDecodingError(let rhs)):
            return lhs.localizedDescription == rhs.localizedDescription
        case (.decodeError(let lhs), .decodeError(let rhs)):
            return lhs == rhs
        case (.unknownError, .unknownError):
            return true
        case (.emptyResponse, .emptyResponse):
            return true
        case (.apiError, .apiError):
            return true
        default:
            return false
        }
    }
}
