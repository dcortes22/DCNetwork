//
//  FormDataParameters.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

struct FormDataParameters: SerializableParameter {
    
    let boundary: String
    var parameters: [String : Any]
    let files: [FileData]
    
    init(boundary: String, parameters: [String : Any], files: [FileData]) {
        self.boundary = boundary
        self.parameters = parameters
        self.files = files
    }
    
    func serialize() throws -> Data {
        var body = Data()
        
        // Agregar parámetros de texto al form-data
        let flatParams = flatten(dictionary: parameters)

        for (key, value) in flatParams {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append(value.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }

        for file in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.mimeType.value)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    private func flatten(dictionary: [String: Any], prefix: String? = nil) -> [(String, String)] {
        var result: [(String, String)] = []

        for (key, value) in dictionary {
            let fullKey = prefix != nil ? "\(prefix!)[\(key)]" : key

            switch value {
            case let nested as [String: Any]:
                result.append(contentsOf: flatten(dictionary: nested, prefix: fullKey))
            case let string as String:
                result.append((fullKey, string))
            case let int as Int:
                result.append((fullKey, String(int)))
            case let double as Double:
                result.append((fullKey, String(double)))
            case let bool as Bool:
                result.append((fullKey, String(bool)))
            default:
                break // omit nil or unsupported types
            }
        }

        return result
    }
}
