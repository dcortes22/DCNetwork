//
//  ParameterSerializer.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

final class ParameterSerializer {
    
    /// Serializes a dictionary of parameters and optional files into a `SerializableParameter` based on the provided content type.
    /// This function takes a dictionary of parameters and, depending on the specified `ContentType`, serializes them into a suitable format. It supports three content types: JSON, URL-encoded forms, and multipart form-data (which can include files). The result is returned as a `SerializableParameter`, which can be further processed or sent in an HTTP request.
    /// - Parameters:
    ///   - parameters: A dictionary containing the parameters to be serialized. Keys are `String` and values can be of various types (`String`, `Int`, `Double`, etc.).
    ///   - contentType: The `ContentType` that determines how the parameters and files should be serialized. Supported types include:
    ///     - `.json`: Serializes parameters as JSON.
    ///     - `.formURLEncoded`: Serializes parameters as URL-encoded form data.
    ///     - `.formData(boundary: String)`: Serializes parameters and files as multipart form-data with a boundary string.
    ///   - files: An array of `FileData` containing files to be included when the `ContentType` is `formData`. This array can be empty for other content types.
    /// - Throws:
    ///     - `NetworkError.invalidParametersSerialization`: If an error occurs during the serialization process.
    /// - Returns:
    ///     - `SerializableParameter`: An instance of `SerializableParameter` that encapsulates the serialized parameters, ready to be sent in an HTTP request body.
    static func serializeParameters(_ parameters: [String: Any], contentType: ContentType, files: [FileData]) throws -> SerializableParameter {
        
        switch contentType {
        case .json:
            return JSONParameters(parameters: parameters)
        case .formURLEncoded:
            return FormURLEncodedParameters(parameters: parameters)
        case .formData(let boundary):
            return FormDataParameters(boundary: boundary, parameters: parameters, files: files)
        }
    }
}
