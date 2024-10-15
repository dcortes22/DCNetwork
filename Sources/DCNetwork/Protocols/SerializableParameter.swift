//
//  SerializableParameter.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

protocol SerializableParameter {
    
    var parameters: [String: Any] { get }
    func serialize() throws -> Data
}
