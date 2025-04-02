//
//  ResponseDecoder.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

final class ResponseDecoder {
    
    /// Decodes the given data into the expected response type for the provided request.
    ///
    /// This function attempts to decode the provided `Data` into the expected response type `R`,
    /// which must conform to `Codable`. If the data is empty, it checks whether `R` conforms to
    /// `ExpressibleByNilLiteral` to allow returning `nil`-equivalent values. If decoding fails,
    /// it catches `DecodingError`, generates a readable error message, and throws a
    /// `NetworkError.decodeError`.
    ///
    /// - Parameters:
    ///   - request: A `DataRequest` object that defines the expected response type (`R`)
    ///              and provides decoding context.
    ///   - data: The raw `Data` to decode.
    ///
    /// - Throws:
    ///   - `NetworkError.emptyResponse`: When `data` is empty and the response type does not allow `nil`.
    ///   - `NetworkError.decodeError`: When the decoding process fails, with an associated message.
    ///
    /// - Returns: The decoded response of type `R`.
    static func decode<T, R>(request: T, from data: Data) throws -> R where T: DataRequest, R: Codable {
        guard !data.isEmpty else {
            if let responseType = R.self as? ExpressibleByNilLiteral.Type {
                return responseType.init(nilLiteral: ()) as! R
            } else {
                throw NetworkError.emptyResponse
            }
        }

        do {
            let decoder = request.decoder()
            return try decoder.decode(R.self, from: data)
        } catch let decodingError as DecodingError {
            let errorMessage = Self.decodeErrorMessage(for: decodingError)
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
