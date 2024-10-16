//
//  ResponseDecoder.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

final class ResponseDecoder {
    
    /// Decodes the given data into the expected response type for the provided request.
    /// This function attempts to decode the provided `Data` into the expected response type `T.Response` as defined by the `DataRequest`. If the decoding fails, it catches the `DecodingError`, generates an appropriate error message, and throws a `NetworkError.decodeError` with the error details.
    /// - Parameters:
    ///     - request: A `DataRequest` object that defines the expected response type (`T.Response`) and provides context for the decoding.
    ///     - data: The raw `Data` to be decoded into the response type.
    /// - Throws:
    ///     - `NetworkError.decodeError`: If the decoding process fails, it throws a `decodeError` containing the detailed error message.
    ///     - `DecodingError`: If an issue occurs during decoding that matches the `DecodingError` cases, such as a type mismatch, missing keys, etc.
    ///     - Other errors: Any other errors that might occur during the decoding process will also be thrown as a `NetworkError.decodeError`.
    /// - Returns:
    ///     - The decoded response of type `T.Response`, which conforms to `Decodable`.
    static func decode<T>(request: T, from data: Data) throws -> T.Response where T: DataRequest {
        do {
            if data.isEmpty {
                if let type = T.Response.self as? ExpressibleByNilLiteral.Type {
                    return type.init(nilLiteral: ()) as! T.Response
                } else {
                    throw NetworkError.emptyResponse
                }
            }
            return try JSONDecoder().decode(T.Response.self, from: data)
        } catch let error as DecodingError {
            let errorMessage = Self.decodeErrorMessage(for: error)
            throw NetworkError.decodeError(errorMessage)
        } catch {
            throw NetworkError.decodeError(error.localizedDescription)
        }
    }
    
    /// Generates a detailed error message for a given `DecodingError`.
    /// This function takes a `DecodingError` and constructs a human-readable error message that includes the path where the decoding failure occurred (`codingPath`) and a detailed description of the error. It handles various cases of `DecodingError` such as type mismatches, missing values, missing keys, and data corruption.
    /// - Parameter error: The `DecodingError` that occurred during decoding, which contains context about the failure.
    /// - Returns:
    ///     - A `String` describing the decoding error, including the field (from `codingPath`) where the error occurred and a description of the specific issue.
    static func decodeErrorMessage(for error: DecodingError) -> String {
        switch error {
        case .typeMismatch(_, let context):
            let codingPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            return "Type mismatch at '\(codingPath)': \(context.debugDescription)"
            
        case .valueNotFound(_, let context):
            let codingPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            return "Value not found at '\(codingPath)': \(context.debugDescription)"
            
        case .keyNotFound(let key, let context):
            let codingPath = (context.codingPath + [key]).map { $0.stringValue }.joined(separator: ".")
            return "Key '\(key.stringValue)' not found at '\(codingPath)': \(context.debugDescription)"
            
        case .dataCorrupted(let context):
            let codingPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            return "Data corrupted at '\(codingPath)': \(context.debugDescription)"
            
        @unknown default:
            return "Unknown decoding error"
        }
    }
}
