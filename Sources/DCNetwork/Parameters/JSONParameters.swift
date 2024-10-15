//
//  JSONParameters.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

struct JSONParameters: SerializableParameter {
    
    var parameters: [String : Any]
    
    init(parameters: [String : Any]) {
        self.parameters = parameters
    }
    
    func serialize() throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
        } catch {
            throw NetworkError.invalidParametersSerialization
        }
    }
}
