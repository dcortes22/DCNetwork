//
//  FormURLEncodedParameters.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

struct FormURLEncodedParameters: SerializableParameter {
    
    var parameters: [String : Any]
    
    init(parameters: [String : Any]) {
        self.parameters = parameters
    }
    
    func serialize() throws -> Data {
        let queryItems = parameters.compactMap { key, value -> String? in
            guard let valueString = Utils.convertToString(value) else { return nil }
            return "\(key)=\(valueString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        let formString = queryItems.joined(separator: "&")
        guard let formData = formString.data(using: .utf8) else {
            throw NetworkError.invalidParametersSerialization
        }
        return formData
    }
}
