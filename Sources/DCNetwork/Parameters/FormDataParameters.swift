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
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            if let valueData = Utils.convertToString(value)?.data(using: .utf8) {
                body.append(valueData)
            }
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
}
